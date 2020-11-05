# frozen_string_literal: true

require "retry_on_error/version"
require "retry_on_error/errors"
require "retry_on_error/retrier"

module RetryOnError
  def self.call(*args, **opts, &block)
    Retrier.call(*args, **opts, &block)
  end
end
