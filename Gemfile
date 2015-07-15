source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.1.0'

gem 'country_select'

gem "activemerchant"

gem "state_machine", "~> 1.2.0"

#MongoDB database connection
gem 'mongoid', github: 'mongoid/mongoid'
gem 'bson_ext' #Needed for mongoid
gem 'mongoid_slug', "~> 3.2" #slugs/permalink
gem 'mongoid_alize'
gem 'carrierwave-mongoid', '~> 0.7.1'
gem "mini_magick", "~> 3.6.0"
gem 'mongoid-grid_fs', github: 'ahoward/mongoid-grid_fs' #required to make carrierwave-mongoid to work

gem 'money-rails', git: "git://github.com/RubyMoney/money-rails.git"

gem 'draper'
gem 'draper-cancan'

gem "sorcery" #Authentication
gem "cancan" #Authorization (roles)

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
gem 'bootstrap-sass'
gem 'anlek_bootstrap_helper', git: "git@gitlab.anlek.com:anlek-consulting/bootstrap-helper.git" #path: "/Users/andrew/code/rails_apps/anlek_bootstrap_helper"
gem 'anlek_nested_helper', git: "git@gitlab.anlek.com:anlek-consulting/nested-helper.git"
gem 'anlek_layout_helper', git: "git@gitlab.anlek.com:anlek-consulting/layout-helper.git"
gem 'font-awesome-rails'
gem 'bootstrap-datepicker-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'


# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem "modernizr-rails"

gem 'simple_form', github: "plataformatec/simple_form"
gem 'select2-rails'
gem "ckeditor"
gem 'non-stupid-digest-assets'

gem "slim-rails"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'


# Use debugger
# gem 'debugger', group: [:development, :test]

# gem 'mysql2'

# gem 'bitmask_attributes'


# Use unicorn as the app server
gem 'unicorn'

group :development, :test do
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "ffaker"
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'pry-remote'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end

group :development do
  gem 'spring'
  gem "spring-commands-rspec"
  gem 'capistrano', '~> 2.15.5'
  gem "letter_opener"
  gem 'shoulda-matchers'
  gem 'quiet_assets'
  gem "hpricot", ">= 0.8.6"
  gem "ruby_parser", ">= 2.3.1"
  gem 'yard'
  gem 'awesome_print'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'meta_request'
end

group :test do
  gem "capybara", ">= 1.1.2"
  gem "database_cleaner", ">= 0.8.0"
  # gem "cucumber-rails", ">= 1.3.0", require: false
  gem "launchy", ">= 2.1.2"

  gem 'mongoid-rspec', github: 'pcreux/mongoid-rspec', branch: 'mongo-4-rspec-3'

  gem 'mocha', require: false

  gem 'brakeman'

  gem 'guard-rspec'
  gem 'guard-shell'
  gem 'guard-brakeman'
  gem 'guard-livereload'
  gem 'ruby_gntp'
  gem 'rb-fsevent', '~> 0.9.1',  require: false
end
