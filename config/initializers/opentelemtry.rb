# config/initializers/opentelemetry.rb
require "opentelemetry/sdk"
require "opentelemetry/instrumentation/all"

OpenTelemetry::SDK.configure do |c|
  c.use_all() # This auto-instruments Rails, HTTP requests, database queries, etc.
end
