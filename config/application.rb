require File.expand_path("../boot", __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DsAuth
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

    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end

    config.relative_url_root = ENV["RAILS_RELATIVE_URL_ROOT"] || ""
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    # app title appears in the header bar
    config.proposition_title = Settings.dsauth.app_title
    # phase governs text indicators and highlight colours
    # presumed values: alpha, beta, live
    config.phase = "alpha"
    # product type may also govern highlight colours
    # known values: information, service
    config.product_type = "service"
    # Feedback URL (URL for feedback link in phase banner)
    # Use 'auto_add_path' for it to add a path link to the new_feedback route
    config.feedback_url = config.relative_url_root + "/feedback/new"

    config.action_mailer.default_url_options = Settings.action_mailer.default_url_options.to_h
    config.action_mailer.smtp_settings = Settings.action_mailer.smtp_settings.to_h

    config.active_record.raise_in_transactional_callbacks = true

    config.action_view.default_form_builder = "AuthFormBuilder"
    config.action_view.field_error_proc = Proc.new {|html_tag, instance| html_tag }
  end
end
