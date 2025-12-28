# frozen_string_literal: true

require 'spec_helper'
require 'puppet_metadata/command/os_versions'
require 'stringio'
require 'json'

describe OsVersionsCommand do
  subject(:command) { described_class.new([], options) }

  include_context 'with mock eol dates'

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
          operatingsystem: 'Archlinux',
        },
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
      it 'displays module name and supported versions' do
        expect { command.run }.to output(/test-module supports these non-EOL operating system versions:/).to_stdout
      end

      it 'shows multiple operating systems' do
        output = capture_stdout { command.run }
        expect(output).to match(/Archlinux:/)
        expect(output).to match(/CentOS:/)
        expect(output).to match(/Debian:/)
        expect(output).to match(/Ubuntu:/)
      end

      it 'includes Archlinux with all versions support' do
        expect { command.run }.to output(/Archlinux: \(supports all versions\)/).to_stdout
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

      context 'with --os filter for Archlinux' do
        let(:options) { super().merge(os: 'Archlinux') }

        it 'only shows Archlinux' do
          output = capture_stdout { command.run }
          expect(output).to match(/Archlinux:/)
          expect(output).not_to match(/CentOS:/)
          expect(output).not_to match(/Debian:/)
          expect(output).not_to match(/Ubuntu:/)
        end
      end
    end

    context 'with --add-missing' do
      let(:options) { super().merge(add_missing: true) }

      it 'adds missing supported OS versions' do
        allow(PuppetMetadata).to receive(:write)
        expect { command.run }.to output(/Added support/).to_stdout
      end

      context 'with --os filter' do
        let(:options) { super().merge(os: 'Debian', add_missing: true) }
        let(:written_data) { [] }

        before do
          allow(PuppetMetadata).to receive(:write) do |_path, metadata|
            written_data << metadata
          end
          capture_stdout { command.run }
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
        expect { command.run }.to output(/Removed EOL operating systems/).to_stdout
      end

      context 'with --os filter' do
        let(:options) { super().merge(os: 'Ubuntu', remove_eol: true) }
        let(:written_data) { [] }

        before do
          allow(PuppetMetadata).to receive(:write) do |_path, metadata|
            written_data << metadata
          end
          capture_stdout { command.run }
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
        expect { capture_stdout { command.run } }.not_to raise_error
      end
    end

    context 'with both --add-missing and --remove-eol' do
      let(:options) { super().merge(add_missing: true, remove_eol: true) }

      it 'runs both operations in sequence' do
        allow(PuppetMetadata).to receive(:write)
        expect { capture_stdout { command.run } }.not_to raise_error
      end
    end

    context 'with --noop' do
      context 'with --add-missing' do
        let(:options) { super().merge(add_missing: true, noop: true) }

        it 'shows what would be added without writing' do
          allow(PuppetMetadata).to receive(:write)
          expect { command.run }.to output(/\[NOOP\] Would add support:/).to_stdout
          expect(PuppetMetadata).not_to have_received(:write)
        end
      end

      context 'with --remove-eol' do
        let(:options) { super().merge(remove_eol: true, noop: true) }

        it 'shows what would be removed without writing' do
          allow(PuppetMetadata).to receive(:write)
          expect { command.run }.to output(/\[NOOP\] Would remove EOL operating systems:/).to_stdout
          expect(PuppetMetadata).not_to have_received(:write)
        end
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
