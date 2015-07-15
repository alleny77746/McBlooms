set_default :whenever_command, "bundle exec whenever"
set_default :whenever_environment, defer { environment }
set_default :whenever_identifier, defer { "#{application}_#{environment}" }
set_default(:whenever_roles) { :app }
require "whenever/capistrano"