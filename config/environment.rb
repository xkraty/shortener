require "opentelemetry/sdk"
require "opentelemetry-instrumentation-logger"

# Load the Rails application.
require_relative "application"

OpenTelemetry::SDK.configure do |c|
  c.use_all
end

# Initialize the Rails application.
Rails.application.initialize!
