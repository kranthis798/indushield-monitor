require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module IndustryPortal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    if ENV["RAILS_ENV"] === 'development'
      require 'dotenv'
      Dotenv.load
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.autoload_paths += %W(#{config.root}/lib) # add this line

    config.eager_load_paths += %W(#{Rails.root}/lib)


    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end

    Time::DATE_FORMATS[:w3c] = "%Y-%m-%dT%H:%M:%S%:z"
    Date::DATE_FORMATS[:w3c] = "%Y-%m-%d"

  end
end
