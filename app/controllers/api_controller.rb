class ApiController < ApplicationController
  def status
    render json: {
      status: "ok",
      uptimeSeconds: (Time.now.utc - STARTED_AT).to_i,
      startedAt: STARTED_AT.iso8601,
      ruby: RUBY_VERSION,
      rails: Rails.version
    }
  end

  def greeting
    render json: {
      # Change GREETING in your app's config vars and watch this update —
      # no redeploy needed:  bld config:set GREETING="Hi team" -a <your-app>
      greeting: ENV.fetch("GREETING", "Hello from Build!")
    }
  end
end
