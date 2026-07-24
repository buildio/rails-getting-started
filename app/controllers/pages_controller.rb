class PagesController < ApplicationController
  def index
    @greeting = ENV.fetch("GREETING", "Hello from Build!")
    @env = {
      deployed_at: STARTED_AT.iso8601,
      ruby_version: RUBY_VERSION,
      rails_version: Rails.version,
      port: ENV.fetch("PORT", 3000),
      uptime: (Time.now.utc - STARTED_AT).to_i
    }
  end
end
