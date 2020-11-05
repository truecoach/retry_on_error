# frozen_string_literal: true

module RetryOnError
  class Retrier
    def self.call(*error_configs, delay: 0.5, max_wait: 0, &block)
      new(*error_configs, delay: delay, max_wait: max_wait, &block).call
    end

    def initialize(*error_configs, delay:, max_wait:, &block)
      self.error_configs = error_configs
      self.delay = delay
      self.max_wait = max_wait
      self.block = block

      validate_configs!
    end

    def call(start_time: Time.now)
      block.call
    rescue StandardError => e
      raise unless retryable?(e, start_time: start_time)

      sleep delay

      call(start_time: start_time)
    end

    private

    attr_accessor :block,
                  :delay,
                  :error_configs,
                  :max_wait

    def retryable?(error, start_time:)
      return false if Time.now - start_time >= max_wait

      error_configs.any? { |c| config_error_match?(c, error) }
    end

    def config_error_match?(error_config, error)
      if error_config.is_a?(Array)
        error.class <= error_config[0] &&
          error.message.match(error_config[1])
      else
        error.class <= error_config
      end
    end

    def validate_configs!
      invalid_config! unless error_configs.respond_to?(:all?)

      return if error_configs.all? { |config| valid_config?(config) }

      invalid_config!
    end

    def valid_config?(config)
      config.is_a?(Array) ? valid_array_config?(config) : valid_single_config?(config)
    rescue StandardError
      false
    end

    def valid_array_config?(config)
      config[0] <= Exception && config[1].is_a?(Regexp)
    end

    def valid_single_config?(config)
      config <= Exception
    end

    def invalid_config!
      msg = <<~MSG

        Invalid error config object.

        Expected an array of either error classes OR
        2 item arrays: [error class, regex]

        Example:

        # [
        #   [ ActiveModel::ValidationError, /message/ ],
        #   CustomError
        # ]

        Instead got:

        # #{error_configs.inspect}
      MSG

      raise InvalidConfigError, msg
    end
  end
end
