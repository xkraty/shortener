# config/initializers/opentelemetry.rb
require "opentelemetry/sdk"
require "opentelemetry/instrumentation/all"
require "opentelemetry/instrumentation/rails"


OpenTelemetry::SDK.configure do |c|
  c.service_name = "ShortnerZ"
  c.service_version = "1.0.0"


  c.use_all()

  c.logger = OpenTelemetry.logger_provider.logger(name: "ShortnerZ", version: "0.1.0")

  c.logger_provider = OpenTelemetry::SDK::Logs::LoggerProvider.new(
    resource: OpenTelemetry::SDK::Resources::Resource.create({
      "service.name" => "ShortnerZ",
      "host.name" => Socket.gethostname
    })
  )

  exporter = OpenTelemetry::Exporter::OTLP::Logs::Exporter.new(endpoint: ENV["OTEL_EXPORTER_OTLP_LOGS_ENDPOINT"])

  processor = OpenTelemetry::SDK::Logs::SimpleLogRecordProcessor.new(exporter)
  c.logger_provider.add_log_record_processor(processor)
end
