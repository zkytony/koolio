require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Koolio
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Read the local_env.yml file
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      if File.exists?(env_file)
        erb_obj = ERB.new(File.read(env_file))
        YAML.load(erb_obj.result).each do |key, value|
          begin
            ENV[key.to_s] = value
          rescue TypeError
            raise TypeError, "#{value}, the value for #{key}, in its original form, cannot be converted to String. Add quotes?"
          end
        end
      end

      env_file = File.join(Rails.root, 'config', 'general.yml')
      if File.exists?(env_file)
        erb_obj = ERB.new(File.read(env_file))
        YAML.load(erb_obj.result).each do |key, value|
          begin
            if key.to_s == "STORAGE_TYPE"
              if value != "fog" && value != "file"
                raise "STORAGE_TYPE must be fog or file. Given: #{value}"
              end
            end
            ENV[key.to_s] = value
          rescue TypeError
            raise TypeError, "#{value}, the value for #{key}, in its original form, cannot be converted to String. Add quotes?"
          end
        end
      end
    end

    config.exceptions_app = self.routes

    config.active_record.raise_in_transactional_callbacks = true
  end
end
