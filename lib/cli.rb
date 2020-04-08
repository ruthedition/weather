require_relative "./api.rb"
require 'pry'

class Weather::CLI

  def greeting
    puts "Welcome to Weather Today!\n\n"
  end 

  def enter_zipcode
    puts "Please enter your zipcode. >"
    gets.strip
  end 

  def call
    greeting
    zipcode = enter_zipcode
    validate_zipcode(zipcode)
  end 

  def valid_zipcode?(zipcode)
    zipcode.length == 5 && zipcode.to_i > 0 

  end 
  
  def invalid_zipcode_response
    puts "Invalid zipcode."
    zipcode = enter_zipcode
    validate_zipcode(zipcode)
  end 

  def validate_zipcode(zipcode)
    if valid_zipcode?(zipcode)
      display_menu
      handle_menu_input(zipcode)
    else 
      invalid_zipcode_response   
    end   
  end 

  def display_menu
    puts "\n1. The temperature for today."
    puts "2. The highs and lows for today."
    puts "3. The humidity today."
    puts "4. Everything for today's forecast."
    puts "5. Exit"
  end 

  def handle_menu_input(zipcode)
    input = gets.strip
    forecast_response = Weather::API.get_forecast(zipcode)
    if forecast_response 
      forecast = Weather::Forecast.new(
        forecast_response[:temp], 
        forecast_response[:feels_like], 
        forecast_response[:temp_min], 
        forecast_response[:temp_max], 
        forecast_response[:humidity]
      )
      forecast.print_temperature if input == "1"
      forecast.print_temp_range if input == "2"
      forecast.print_humidity if input == "3"
      forecast.print_everything if input == "4"
      if input == "5"
        puts "Goodbye"
      else 
        display_menu
        handle_menu_input(zipcode) 
      end 
    else
      invalid_zipcode_response
    end 
  end 

end 

