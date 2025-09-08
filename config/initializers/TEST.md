in ordine:

```
gem 'opentelemetry-sdk'
gem 'opentelemetry-exporter-otlp'
gem 'opentelemetry-instrumentation-all'

gem 'opentelemetry-logs-api'
gem 'opentelemetry-logs-sdk'
gem 'opentelemetry-exporter-otlp-logs'
```


Initializer: 

```
# require 'opentelemetry/sdk'
# require 'opentelemetry/exporter/otlp'
# require 'opentelemetry/instrumentation/all'

# require 'opentelemetry/logs'
# require 'opentelemetry/sdk/logs'
# require 'opentelemetry/exporter/otlp/logs'

OpenTelemetry::SDK.configure do |c|
  c.service_name = 'dpp-tester'
  c.service_version = '1.0.0'


  c.use_all()

  # Debugging - rimuovi in produzione
  c.logger = OpenTelemetry.logger_provider.logger(name: 'dpp-tester', version: '0.1.0')

  c.logger_provider = OpenTelemetry::SDK::Logs::LoggerProvider.new(
    resource: OpenTelemetry::SDK::Resources::Resource.create({
      'service.name' => 'dpp-tester',
      'host.name' => Socket.gethostname
    })
  )

  exporter = OpenTelemetry::Exporter::OTLP::Logs::Exporter.new(endpoint: ENV["OTEL_EXPORTER_OTLP_LOGS_ENDPOINT"])

  processor = OpenTelemetry::SDK::Logs::SimpleLogRecordProcessor.new(exporter)
  c.logger_provider.add_log_record_processor(processor)
end

```

> .env

```
OTEL_EXPORTER=otlp
OTEL_EXPORTER_OTLP_ENDPOINT=https://signoz.egallo.dev
OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf
OTEL_EXPORTER_OTLP_TIMEOUT=90
OTEL_EXPORTER_OTLP_COMPRESSION=gzip
OTEL_LOG_LEVEL=debug
OTEL_SERVICE_NAME=DPPTester
OTEL_RESOURCE_ATTRIBUTES=application=dpp_tester

OTEL_LOGS_EXPORTER=otlp
OTEL_EXPORTER_OTLP_LOGS_ENDPOINT=https://signoz.egallo.dev
OTEL_EXPORTER_OTLP_LOGS_PROTOCOL=http/protobuf
OTEL_EXPORTER_OTLP_LOGS_TIMEOUT=90
OTEL_EXPORTER_OTLP_LOGS_COMPRESSION=gzip
```