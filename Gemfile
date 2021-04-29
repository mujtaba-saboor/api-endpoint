source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.0.3.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'active_model_serializers', '0.10.0.rc4'
gem 'airbrake', '10.0.5'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem 'mysql2', '=0.5.3'
gem 'will_paginate', '=3.3.0'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  gem 'pry', '=0.13.1'
  gem 'puma', '=5.1.1'
  gem 'rspec-rails', '=4.0.1'
end

group :development do
  gem 'listen', '=3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner', '=2.0.1'
  gem 'factory_bot_rails', '=6.1.0'
  gem 'faker', '=2.17.0'
  gem 'shoulda-matchers', '=4.5.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
