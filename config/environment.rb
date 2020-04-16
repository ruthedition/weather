require "./config/version"
require "./lib/cli"
require "dotenv/load"
require "./lib/api"
require "./lib/forecast"
require "pry"
require "table_print"
require "./config/print_config"

module Weather
  class Error < StandardError; end
  PrintConfig.table_config
end
