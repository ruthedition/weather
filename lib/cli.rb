require_relative "./api.rb"
require 'pry'

class CLI

  def call
    puts "Welcome to Weather Today!"
    puts "Please enter a zip code for the forecast in that area > "
    zipcode = gets.strip
    get_weather(zipcode) if valid_zipcode?(zipcode) 
  end 

  def valid_zipcode?(zipcode)
    zipcode.length == 5 ? true : false 
  end 
  
  def get_weather(zipcode)
    forecast = API.get_forecast(zipcode)
  end 

end 