require "selenium-webdriver"
require "csv"
require "logger"

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each do |file|
  require(file) unless File.basename(file) == "main.rb"
end

$logger = Logger.new("tmp/log.txt") unless ENV["SCRIPT_ENV"] == "test"
