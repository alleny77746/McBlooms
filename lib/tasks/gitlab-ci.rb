require 'fileutils'
namespace :gitlab_ci do
  desc "Setup file before testing"
  task setup: :environment do
    root = Rails.root.join("config")
    Dir["#{root}/**/*.ci.*"].reject{|file| ['.', '..'].include? file}.each do |file|
      puts "Copying file #{file} to #{file.gsub(/\.ci\./, ".")}"
      FileUtils.cp file, file.gsub(/\.ci\./, ".")
    end
  end
end