require_relative "./api.rb"
require 'pry'

class CLI

  def call
    puts "Welcome to Weather Today!"
    puts "Please enter a zipcode for the forecast in that area > "
    zipcode = gets.strip
    if valid_zipcode?(zipcode) 
      forecast = API.get_forecast(zipcode) 
      print_weather(forecast)
    end 
  end 

  def valid_zipcode?(zipcode)
    zipcode.length == 5 ? true : false 
  end 
  
  def print_weather(forecast)
    puts "The temperature today is #{forecast.temperature}, but it feels like #{forecast.feels_like}."
    puts "The low for today is #{forecast.lowest_temperature}, and the high today is #{forecast.highest_temperature}."
  end 

end 


