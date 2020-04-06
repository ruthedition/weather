require_relative "./api.rb"
require 'pry'

class CLI

  def call
    puts "Welcome to Weather Today!"
    puts "Please enter your zipcode. > "
    zipcode = gets.strip
    if valid_zipcode?(zipcode) 
      display_menu
      handle_menu_input
      # forecast = API.get_forecast(zipcode) 
      # print_weather(forecast)
    end 
  end 

  def valid_zipcode?(zipcode)
    zipcode.length == 5 ? true : false 
  end 
  
  def display_menu
    puts "1. The temperature for today."
    puts "2. The highs and lows for today."
    puts "3. The humidity today."
    puts "4. Everything for today's forecast."
  end 

  def handle_menu_input
  end 


  def print_weather(forecast)
    puts "The temperature today is #{forecast.temperature}, but it feels like #{forecast.feels_like}."
    puts "The low for today is #{forecast.lowest_temperature}, and the high today is #{forecast.highest_temperature}."
  end 

end 


