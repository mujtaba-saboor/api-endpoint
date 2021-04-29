# frozen_string_literal: true

# Airbrake is an online tool that provides robust exception tracking in your Rails
# applications. In doing so, it allows you to easily review errors, tie an error
# to an individual piece of code, and trace the cause back to recent
# changes. Airbrake enables for easy categorization, searching, and prioritization
# of exceptions so that when errors occur, your team can quickly determine the
# root cause.
#
# Configuration details:
# https://github.com/airbrake/airbrake-ruby#configuration

if Rails.env.production?
  Airbrake.configure do |config|
    # You must set both project_id & project_key. To find your project_id and
    # project_key navigate to your project's General Settings and copy the values
    # from the right sidebar.
    # https://github.com/airbrake/airbrake-ruby#project_id--project_key
    config.project_id = 52217
    config.project_key = 'da05a29cfb8959330848025a03e9ebf3'
    config.blocklist_keys = Rails.application.config.filter_parameters
    # Configures Airbrake Performance Monitoring statistics collection aggregated per route.
    # These are displayed on the Performance tab of your project. By default, it's enabled.
    config.performance_stats = false

    # Configures the root directory of your project. Expects a String or a
    # Pathname, which represents the path to your project. Providing this option
    # helps us to filter out repetitive data from backtrace frames and link to
    # GitHub files from our dashboard.
    # https://github.com/airbrake/airbrake-ruby#root_directory
    config.root_directory = Rails.root
    config.environment = Rails.env

    # By default, Airbrake Ruby outputs to STDOUT. In Rails apps it makes sense to
    # use the Rails' logger.
    # https://github.com/airbrake/airbrake-ruby#logger
    # config.logger = Airbrake::Rails.logger
  end
elsif Rails.env.staging?
  Airbrake.configure do |config|
    config.host = 'http://54.241.167.211'
    config.project_id = 1 # required, but any positive integer works
    config.project_key = '863ef7e7b305402732120550750ed79d'
    # Configures Airbrake Performance Monitoring statistics collection aggregated per route.
    # These are displayed on the Performance tab of your project. By default, it's enabled.
    config.performance_stats = false
    config.environment = Rails.env
  end
end

# A filter that collects request body information. Enable it if you are sure you
# don't send sensitive information to Airbrake in your body (such as passwords).
# https://github.com/airbrake/airbrake#requestbodyfilter
# Airbrake.add_filter(Airbrake::Rack::RequestBodyFilter.new)

# Attaches thread & fiber local variables along with general thread information.
# Airbrake.add_filter(Airbrake::Filters::ThreadFilter.new)

# Attaches loaded dependencies to the notice object
# (under context/versions/dependencies).
# Airbrake.add_filter(Airbrake::Filters::DependencyFilter.new)

# If you want to convert your log messages to Airbrake errors, we offer an
# integration with the Logger class from stdlib.
# https://github.com/airbrake/airbrake#logger
# Rails.logger = Airbrake::AirbrakeLogger.new(Rails.logger)
