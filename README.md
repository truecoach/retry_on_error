[![Gem Version](https://badge.fury.io/rb/retry_on_error.svg)](https://badge.fury.io/rb/retry_on_error)
[![Build Status](https://travis-ci.com/truecoach/retry_on_error.svg?branch=main)](https://travis-ci.com/truecoach/retry_on_error)

# RetryOnError

A simple utility for configuring retry behavior based on errors.

```ruby
gem 'retry_on_error'
```

## Usage

```ruby
flaky_call = -> { Intercom::Client.new(...).users.create(params) }

# basic usage
# +max_wait: the maximum number of seconds the retries are allowed to take
# +delay: wait time (slee) between retries
RetryOnError.call(
  Intercom::ServerError,
  max_wait: 1,
  delay: 1
) do
  flaky_call.call()
end

# only retry errors with matching messages
RetryOnError.call(
  [ Intercom::ServerError, /error message regex/ ],
  max_wait: 1
) do
  flaky_call.call()
end

# retry on a variety of matching errors
RetryOnError.call(
  Intercom::ServiceUnavailableError,
  [ Intercom::ServerError, /error message regex/ ],
  max_wait: 1
) do
  flaky_call.call()
end
```

## Local development

```bash
$ bundle install
$ bundle exec rspec spec
```

## Contributions

Contributions welcomed! Please link an issue in every pull request, and please include tests.
