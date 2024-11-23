Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new

  config.lograge.custom_options = lambda do |event|
    {
      time: Time.now.utc,
      params: event.payload[:params].reject { |k| %w[controller action].include?(k) },
      level: "info",
      exception: event.payload[:exception]&.first,
      exception_message: event.payload[:exception]&.last,
      user_id: event.payload[:user_id],
      request_id: event.payload[:request_id]
    }.compact
  end
end
