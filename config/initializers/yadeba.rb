# config/initializers/yabeda.rb
require "yabeda/prometheus"

# Metrics configuration
Yabeda.configure do
  group :app do
    counter :links_created_total do
      comment "How many short links have been created"
      tags %i[status]
    end

    counter :link_visits_total do
      comment "How many times links have been visited"
      tags %i[status]
    end

    gauge :active_links do
      comment "Number of active links"
    end

    histogram :link_access_duration do
      comment "Time spent processing link redirects"
      unit :seconds
      buckets [ 0.01, 0.05, 0.1, 0.5, 1 ]
      tags %i[status]
    end
  end
end

Yabeda.configure!

# Strict Authentication Middleware
class MetricsAuth
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"] == "/metrics"
      auth = Rack::Auth::Basic::Request.new(env)
      return unauthorized unless auth.provided? && auth.basic?

      username = auth.credentials.first
      password = auth.credentials.last

      if valid_credentials?(username, password)
        @app.call(env)
      else
        unauthorized
      end
    else
      @app.call(env)
    end
  end

  private

  def valid_credentials?(username, password)
    expected_username = ENV.fetch("METRICS_USERNAME", "metrics")
    expected_password = ENV.fetch("METRICS_PASSWORD", "secret")

    ActiveSupport::SecurityUtils.secure_compare(username, expected_username) &&
    ActiveSupport::SecurityUtils.secure_compare(password, expected_password)
  end

  def unauthorized
    [ 401, { "Content-Type" => "text/plain", "WWW-Authenticate" => 'Basic realm="Metrics"' }, [ "Unauthorized" ] ]
  end
end

# Mount the metrics endpoint with authentication
Rails.application.config.middleware.use MetricsAuth
Rails.application.config.middleware.use Yabeda::Prometheus::Exporter, path: "/metrics"
