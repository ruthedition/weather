require_relative "./api.rb"
require 'pry'

class CLI

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
    zip = zipcode.to_i.to_s
    zip.length == 5 
   
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
    forecast = API.get_forecast(zipcode)
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
  end 

end 


