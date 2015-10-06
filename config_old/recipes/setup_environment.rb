# ENVIRONMENT SETUP
set_default :environments, [:Staging, :Production]

if ENV['production']
  set :environment, :production
else
  set_default(:environment, choose do |menu|
    environments.each { |choice| menu.choice(choice) { set(:environment,choice.to_s.downcase.to_sym) }}
    menu.choice("Cancel and Exit") { exit 0 }
    menu.default = environments.first.to_s
    menu.prompt = "Deploy to which environment?"
  end)
end

set_default(:rails_env, environment) # Because some receipts require this variable

puts "**** ENVIRONMENT #{environment.to_s.upcase} ****"

load "config/deploy.#{environment}"