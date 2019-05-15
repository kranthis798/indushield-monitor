source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'active_model_serializers'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'turbolinks'
gem 'devise'
gem 'jwt'
gem 'api-pagination'
gem 'twilio-ruby'
gem 'rack-cors', require: 'rack/cors'
gem 'jbuilder', '~> 2.0'
gem 'slim-rails'
gem 'rails_admin', '~> 1.3'
gem 'rails_admin_history_rollback'
gem 'rspec'
gem "s3"
gem 'rswag'
gem 'brakeman', require: false
gem 'simplecov', require: false
gem 'enumerize' #selects and enums in models
gem "paperclip", "~> 5.0.0"
gem 'paper_trail'
gem 'aws-sdk', '~> 2.3'
gem "select2-rails"

gem 'foundation-rails', '6.1.2.0'
gem 'foundation-icons-sass-rails'
gem 'foundation-datepicker-rails'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'dotenv-rails'
  gem 'rspec_junit_formatter'
  gem 'database_cleaner'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'factory_bot_rails', '~> 4.0'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'
end

gem "pundit" #for user authorization

#pagination
gem 'kaminari'
gem "gon" #moving data to JS.
gem "momentjs-rails" #javascript date/time
gem "timezone"
gem "rails_admin_pundit", :github => "sudosu/rails_admin_pundit"
gem 'puma_worker_killer' #help manage out of control dynos until we can nail down memory issues.

