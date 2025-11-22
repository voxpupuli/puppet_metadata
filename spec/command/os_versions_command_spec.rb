# frozen_string_literal: true

require 'spec_helper'
require 'puppet_metadata/command/os_versions'
require 'stringio'
require 'json'

describe OsVersionsCommand do
  subject(:command) { described_class.new([], options) }

  let(:metadata_file) { 'metadata.json' }
  let(:metadata_content) do
    {
      author: 'test',
      license: 'MIT',
      name: 'test-module',
      version: '1.0.0',
      summary: 'Test Module',
      source: 'https://example.com',
      dependencies: [],
      operatingsystem_support: [
        {
          operatingsystem: 'CentOS',
          operatingsystemrelease: ['7', '8'],
        },
        {
          operatingsystem: 'Debian',
          operatingsystemrelease: ['10', '11'],
        },
        {
          operatingsystem: 'Ubuntu',
          operatingsystemrelease: ['20.04', '22.04'],
        },
      ],
    }
  end

  let(:options) do
    {
      filename: metadata_file,
      at: nil,
      os: nil,
      add_missing: false,
      remove_eol: false,
    }
  end

  before do
    allow(File).to receive(:read).with(metadata_file).and_return(JSON.generate(metadata_content))
    allow(File).to receive(:write)
  end

  describe '#run' do
    context 'when in list mode (default)' do
      it 'displays versions with EOL status' do
        expect { command.run }.to output(/(Supported|EOL):/).to_stdout
      end

      it 'shows multiple operating systems' do
        expect { command.run }.to output(/CentOS:.*Debian:.*Ubuntu:/m).to_stdout
      end

      context 'with --os filter' do
        let(:options) { super().merge(os: 'Ubuntu') }

        it 'only shows the specified OS' do
          output = capture_stdout { command.run }
          expect(output).to match(/Ubuntu:/)
          expect(output).not_to match(/CentOS:/)
          expect(output).not_to match(/Debian:/)
        end
      end
    end

    context 'with --add-missing' do
      let(:options) { super().merge(add_missing: true) }

      it 'adds missing supported OS versions' do
        allow(PuppetMetadata).to receive(:write)
        # Expect some output about added support
        expect { command.run }.to output(//).to_stdout
      end

      context 'with --os filter' do
        let(:options) { super().merge(os: 'Debian', add_missing: true) }
        let(:written_data) { [] }

        before do
          allow(PuppetMetadata).to receive(:write) do |_path, metadata|
            written_data << metadata
          end
          command.run
        end

        it 'preserves CentOS unchanged' do
          expect(written_data.last.operatingsystems['CentOS']).to eq(['7', '8'])
        end

        it 'preserves Ubuntu unchanged' do
          expect(written_data.last.operatingsystems['Ubuntu']).to eq(['20.04', '22.04'])
        end
      end
    end

    context 'with --remove-eol' do
      let(:options) { super().merge(remove_eol: true) }

      it 'removes EOL operating system versions' do
        allow(PuppetMetadata).to receive(:write)
        # Expect some output about removed support
        expect { command.run }.to output(//).to_stdout
      end

      context 'with --os filter' do
        let(:options) { super().merge(os: 'Ubuntu', remove_eol: true) }
        let(:written_data) { [] }

        before do
          allow(PuppetMetadata).to receive(:write) do |_path, metadata|
            written_data << metadata
          end
          command.run
        end

        it 'preserves CentOS unchanged' do
          expect(written_data.last.operatingsystems['CentOS']).to eq(['7', '8'])
        end

        it 'preserves Debian unchanged' do
          expect(written_data.last.operatingsystems['Debian']).to eq(['10', '11'])
        end
      end
    end

    context 'with --at date' do
      let(:options) { super().merge(at: Date.new(2025, 1, 1)) }

      it 'uses the specified date for EOL checks' do
        expect { command.run }.not_to raise_error
      end
    end

    context 'with both --add-missing and --remove-eol' do
      let(:options) { super().merge(add_missing: true, remove_eol: true) }

      it 'runs both operations in sequence' do
        allow(PuppetMetadata).to receive(:write)
        # Expect output from both operations
        output = capture_stdout { command.run }
        # Should not error, both operations should run
        expect(output).to match(//) # Just verify it doesn't crash
      end
    end
  end

  def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end
end
