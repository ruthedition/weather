require "./config/version"
require "./lib/cli"
require "dotenv/load"
require "./lib/api"
require "./lib/forecast"

module Weather
  class Error < StandardError; end
  # Your code goes here...
end
