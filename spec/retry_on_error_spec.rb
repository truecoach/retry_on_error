# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RetryOnError, '::call' do
  let(:max_wait) { 0.5 }
  let(:delay) { 0 }
  let(:error_configs) { [[StandardError, /^matched message/]] }
  let(:action) { -> {} }

  def call
    described_class.call(*error_configs, delay: delay, max_wait: max_wait) { action.call }
  end

  context 'when the block raises an accepted exception' do
    let(:action) do
      -> do
        @count ||= 0
        @count += 1
        raise 'matched message'
      end
    end

    it 'calls the block multiple times' do
      expect { call }.to raise_error(StandardError)
      expect(@count).to be > 0
    end
  end

  context 'when the block does not raise a recognized exception' do
    let(:action) do
      -> do
        @count ||= 0
        @count += 1
        raise 'unmatched message'
      end
    end

    it 'calls the block once' do
      expect { call }.to raise_error(/unmatched message/)

      expect(@count).to eq(1)
    end
  end

  context 'when a 1-D config is matched' do
    let(:action) do
      -> do
        @count ||= 0
        @count += 1
        raise 'expected message'
      end
    end
    let(:error_configs) { [StandardError] }

    it 'retries the block' do
      expect { call }.to raise_error(/expected message/)

      expect(@count).to be > 0
    end
  end

  context 'when a 1-D error config has a non error class item' do
    let(:error_configs) { ['invalid'] }

    it 'throws an error' do
      expect { call }.to raise_error(described_class::InvalidConfigError)
    end
  end

  context 'when a 2-D error config does not have the required error' do
    let(:error_configs) { [['StandardError', //]] }

    it 'throws an error' do
      expect { call }.to raise_error(described_class::InvalidConfigError)
    end
  end

  context 'when a 2-D error config does not have the required regex' do
    let(:error_configs) { [[StandardError, nil]] }

    it 'throws an error' do
      expect { call }.to raise_error(described_class::InvalidConfigError)
    end
  end
end
