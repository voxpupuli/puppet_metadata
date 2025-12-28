# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'net/http'
require 'date'
require 'tmpdir'
require 'fileutils'

# Load the script functions
load File.expand_path('../bin/update_eol_dates', __dir__)

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'update_eol_dates' do
  # Helper to avoid noisy output during tests
  def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
  ensure
    $stdout = original_stdout
  end

  describe 'OS_MAPPING' do
    it 'contains all expected operating systems' do
      expect(OS_MAPPING.keys).to include(
        'AlmaLinux', 'Amazon', 'CentOS', 'Debian', 'OracleLinux',
        'Fedora', 'FreeBSD', 'RedHat', 'Rocky', 'Scientific', 'SLES', 'Ubuntu'
      )
    end

    it 'maps to valid endoflife.date product IDs' do
      OS_MAPPING.each_value do |product_id|
        next if product_id.nil? # Skip Scientific Linux which isn't in the API

        expect(product_id).to be_a(String)
        expect(product_id).not_to be_empty
      end
    end

    it 'has nil mapping for Scientific Linux' do
      expect(OS_MAPPING['Scientific']).to be_nil
    end
  end

  describe '#parse_eol_date' do
    it 'parses valid date strings' do
      expect(parse_eol_date('2024-06-30')).to eq('2024-06-30')
      expect(parse_eol_date('2025-12-31')).to eq('2025-12-31')
    end

    it 'returns nil for false (not yet EOL)' do
      expect(parse_eol_date(false)).to be_nil
      expect(parse_eol_date('false')).to be_nil
    end

    it 'returns nil for true (EOL date unknown)' do
      expect(parse_eol_date(true)).to be_nil
      expect(parse_eol_date('true')).to be_nil
    end

    it 'returns nil for invalid date strings' do
      expect(parse_eol_date('invalid-date')).to be_nil
      expect(parse_eol_date('2024-13-45')).to be_nil
    end

    it 'returns nil for nil input' do
      expect(parse_eol_date(nil)).to be_nil
    end
  end

  describe '#fetch_eol_data' do
    let(:product) { 'ubuntu' }
    let(:mock_response_body) do
      [
        { 'cycle' => '24.04', 'eol' => '2029-04-25' },
        { 'cycle' => '22.04', 'eol' => '2027-04-21' },
      ].to_json
    end

    context 'with successful API response' do
      before do
        stub_request = instance_double(Net::HTTPSuccess)
        allow(stub_request).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
        allow(stub_request).to receive(:body).and_return(mock_response_body)
        allow(Net::HTTP).to receive(:get_response).and_return(stub_request)
      end

      it 'fetches and parses JSON data' do
        result = fetch_eol_data(product)
        expect(result).to be_an(Array)
        expect(result.length).to eq(2)
        expect(result.first['cycle']).to eq('24.04')
      end
    end

    context 'with failed API response' do
      before do
        stub_response = instance_double(Net::HTTPNotFound)
        allow(stub_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
        allow(stub_response).to receive_messages(code: '404', message: 'Not Found')
        allow(Net::HTTP).to receive(:get_response).and_return(stub_response)
      end

      it 'returns nil and warns on HTTP error' do
        result = nil
        expect { result = fetch_eol_data('invalid-product') }.to output(/Failed to fetch data/).to_stderr
        expect(result).to be_nil
      end
    end

    context 'with network error' do
      before do
        allow(Net::HTTP).to receive(:get_response).and_raise(StandardError, 'Connection failed')
      end

      it 'returns nil and warns on exception' do
        result = nil
        expect { result = fetch_eol_data(product) }.to output(/Error fetching data/).to_stderr
        expect(result).to be_nil
      end
    end
  end

  describe '#update_os_data' do
    let(:os_name) { 'TestOS' }
    let(:product_id) { 'testos' }
    let(:current_data) do
      {
        'TestOS' => {
          '1.0' => '2020-01-01',
          '2.0' => nil,
        },
      }
    end
    let(:api_data) do
      [
        { 'cycle' => '3.0', 'eol' => '2030-12-31' },
        { 'cycle' => '2.0', 'eol' => false },
        { 'cycle' => '1.0', 'eol' => '2020-01-01' },
      ]
    end

    before do
      allow(self).to receive(:fetch_eol_data).with(product_id).and_return(api_data)
    end

    it 'updates OS data from API' do
      result = capture_stdout { update_os_data(os_name, product_id, current_data) }
      expect(result).to be_a(Hash)
      expect(result['3.0']).to eq('2030-12-31')
      expect(result['2.0']).to be_nil
      expect(result['1.0']).to eq('2020-01-01')
    end

    it 'preserves versions not in API' do
      current_with_extra = {
        'TestOS' => {
          '0.5' => '2015-01-01',
          '1.0' => '2020-01-01',
        },
      }
      result = capture_stdout { update_os_data(os_name, product_id, current_with_extra) }
      expect(result['0.5']).to eq('2015-01-01')
    end

    it 'returns current data when product_id is nil' do
      result = capture_stdout { update_os_data(os_name, nil, current_data) }
      expect(result).to eq(current_data)
    end

    it 'returns current data when API fetch fails' do
      allow(self).to receive(:fetch_eol_data).and_return(nil)
      result = capture_stdout { update_os_data(os_name, product_id, current_data) }
      expect(result).to eq(current_data)
    end

    context 'when updating Debian' do
      let(:os_name) { 'Debian' }
      let(:product_id) { 'debian' }
      let(:current_data) { { 'Debian' => { '12' => '2026-06-10' } } }
      let(:api_data) do
        [
          { 'cycle' => '12', 'eol' => '2026-06-10', 'extendedSupport' => '2028-06-30' },
        ]
      end

      it 'uses extendedSupport when present' do
        result = capture_stdout { update_os_data(os_name, product_id, current_data) }
        expect(result['12']).to eq('2028-06-30')
      end
    end
  end

  describe '#handle_amazon_linux' do
    let(:current_data) do
      {
        'Amazon' => {
          '2018.03' => '2023-12-31',
        },
      }
    end
    let(:al_data) do
      [
        { 'cycle' => '2023', 'eol' => false },
        { 'cycle' => '2', 'eol' => '2025-06-30' },
        { 'cycle' => '2018.03', 'eol' => '2023-12-31' },
      ]
    end

    before do
      allow(self).to receive(:fetch_eol_data).with('amazon-linux').and_return(al_data)
    end

    it 'combines data from all Amazon Linux versions' do
      result = capture_stdout { handle_amazon_linux(current_data) }
      expect(result).to be_a(Hash)
      expect(result['2018.03']).to eq('2023-12-31')
      expect(result['2.0']).to eq('2025-06-30') # AL2 cycle "2" mapped to "2.0"
    end

    it 'maps AL2 cycle "2" to version "2.0"' do
      result = capture_stdout { handle_amazon_linux(current_data) }
      expect(result).to have_key('2.0')
      expect(result).not_to have_key('2')
    end

    it 'preserves versions not in any API' do
      current_with_extra = {
        'Amazon' => {
          '2017.03' => '2020-12-31',
          '2018.03' => '2023-12-31',
        },
      }
      result = capture_stdout { handle_amazon_linux(current_with_extra) }
      expect(result['2017.03']).to eq('2020-12-31')
    end

    it 'handles API failures gracefully' do
      allow(self).to receive(:fetch_eol_data).and_return(nil)
      expect { capture_stdout { handle_amazon_linux(current_data) } }.not_to raise_error
    end
  end

  describe '#handle_centos' do
    let(:current_data) do
      {
        'CentOS' => {
          '7' => '2024-06-30',
        },
      }
    end
    let(:centos_data) do
      [
        { 'cycle' => '8', 'eol' => '2021-12-31' },
        { 'cycle' => '7', 'eol' => '2024-06-30' },
        { 'cycle' => '6', 'eol' => '2020-11-30' },
      ]
    end
    let(:stream_data) do
      [
        { 'cycle' => '10', 'eol' => '2030-01-01' },
        { 'cycle' => '9', 'eol' => '2027-05-31' },
        { 'cycle' => '8', 'eol' => '2024-05-31' },
      ]
    end

    before do
      allow(self).to receive(:fetch_eol_data).with('centos').and_return(centos_data)
      allow(self).to receive(:fetch_eol_data).with('centos-stream').and_return(stream_data)
    end

    it 'combines data from both CentOS and CentOS Stream APIs' do
      result = capture_stdout { handle_centos(current_data) }
      expect(result).to be_a(Hash)
      expect(result['7']).to eq('2024-06-30')
      expect(result['9']).to eq('2027-05-31')
      expect(result['10']).to eq('2030-01-01')
    end

    it 'uses Stream EOL date when version exists in both APIs' do
      result = capture_stdout { handle_centos(current_data) }
      # CentOS 8 appears in both APIs, Stream version should win (later in processing)
      expect(result['8']).to eq('2024-05-31') # Stream version, not 2021-12-31
    end

    it 'preserves versions not in any API' do
      current_with_extra = {
        'CentOS' => {
          '4' => '2012-02-29',
          '7' => '2024-06-30',
        },
      }
      result = capture_stdout { handle_centos(current_with_extra) }
      expect(result['4']).to eq('2012-02-29')
    end

    it 'handles API failures gracefully' do
      allow(self).to receive(:fetch_eol_data).and_return(nil)
      expect { capture_stdout { handle_centos(current_data) } }.not_to raise_error
    end
  end

  describe '#handle_ubuntu' do
    let(:current_data) do
      {
        'Ubuntu' => {
          '24.04' => '2029-05-31',
          '23.10' => '2024-07-12',
          '6.06' => '2011-06-01',
        },
      }
    end

    let(:ubuntu_api_data) do
      [
        { 'cycle' => '25.10', 'eol' => '2026-07-01', 'lts' => false },
        { 'cycle' => '23.10', 'eol' => '2024-07-12', 'lts' => false },
        { 'cycle' => '24.04', 'eol' => '2029-05-31', 'lts' => true },
        { 'cycle' => '22.04', 'eol' => '2027-04-01', 'lts' => true },
        { 'cycle' => '20.04', 'eol' => '2025-05-31', 'lts' => true },
      ]
    end

    before do
      allow(self).to receive(:fetch_eol_data).with('ubuntu').and_return(ubuntu_api_data)
    end

    it 'includes all releases from the API' do
      result = capture_stdout { handle_ubuntu(current_data) }
      expect(result).to be_a(Hash)
      expect(result).to have_key('24.04')
      expect(result).to have_key('22.04')
      expect(result).to have_key('20.04')
      expect(result).to have_key('23.10')
      expect(result).to have_key('25.10')
    end

    it 'preserves versions from current data that are not in the API' do
      allow(self).to receive(:fetch_eol_data).with('ubuntu').and_return([
                                                                          { 'cycle' => '24.04', 'eol' => '2029-05-31', 'lts' => true },
                                                                        ])

      result = capture_stdout { handle_ubuntu(current_data) }
      expect(result).to have_key('24.04')
      expect(result).to have_key('6.06')
      expect(result).to have_key('23.10')
    end

    it 'handles API failures gracefully' do
      allow(self).to receive(:fetch_eol_data).and_return(nil)
      expect { capture_stdout { handle_ubuntu(current_data) } }.not_to raise_error
    end
  end

  describe 'sorting logic' do
    let(:unsorted_versions) do
      {
        '10' => '2030-01-01',
        '9' => '2030-01-01',   # Same EOL date as 10
        '8' => '2025-06-30',
        '11' => nil,           # Not yet EOL
        '7' => '2024-06-30',
      }
    end

    let(:sorted) do
      unsorted_versions.sort do |a, b|
        version_a, eol_a = a
        version_b, eol_b = b

        # Handle nil values (not yet EOL) - they go first
        next -1 if eol_a.nil? && !eol_b.nil?
        next 1 if !eol_a.nil? && eol_b.nil?

        if eol_a == eol_b
          # Same EOL date (or both nil) - sort by version number descending
          Gem::Version.new(version_b) <=> Gem::Version.new(version_a)
        else
          # Different EOL dates - sort by date descending (later date first)
          (eol_b || '0000-00-00') <=> (eol_a || '0000-00-00')
        end
      end.to_h
    end

    it 'puts nil EOL versions first' do
      expect(sorted.keys[0]).to eq('11')
    end

    it 'sorts same EOL dates by version number descending' do
      expect(sorted.keys[1]).to eq('10')  # 2030-01-01, higher version
      expect(sorted.keys[2]).to eq('9')   # 2030-01-01, lower version
    end

    it 'sorts different EOL dates descending' do
      expect(sorted.keys[3]).to eq('8')   # 2025-06-30
      expect(sorted.keys[4]).to eq('7')   # 2024-06-30
    end
  end

  describe 'integration with data file' do
    let(:tmpdir) { Dir.mktmpdir }
    let(:data_dir) { File.join(tmpdir, 'data') }
    let(:data_file) { File.join(data_dir, 'eol_dates.json') }
    let(:initial_data) do
      {
        'Ubuntu' => {
          '22.04' => '2027-04-21',
          '20.04' => '2025-04-23',
        },
      }
    end

    before do
      FileUtils.mkdir_p(data_dir)
      File.write(data_file, JSON.pretty_generate(initial_data))
    end

    after do
      FileUtils.rm_rf(tmpdir)
    end

    it 'reads and writes JSON data correctly' do
      data = JSON.parse(File.read(data_file))
      expect(data).to eq(initial_data)

      updated_data = initial_data.merge('Debian' => { '12' => '2028-06-10' })
      File.write(data_file, JSON.pretty_generate(updated_data))

      reloaded_data = JSON.parse(File.read(data_file))
      expect(reloaded_data).to eq(updated_data)
    end

    it 'preserves JSON formatting with pretty_generate' do
      File.write(data_file, "#{JSON.pretty_generate(initial_data)}\n")
      content = File.read(data_file)
      expect(content).to include("\n")
      expect(content).to match(/^\{/)
      expect(content).to end_with("\n")
    end
  end
end
# rubocop:enable RSpec/DescribeClass
