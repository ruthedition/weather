require_relative "./api.rb"
require 'pry'

class CLI

  def greeting
    puts "Welcome to Weather Today!\n\n"
  end 

  def enter_zipcode
    puts "Please enter your zipcode. > "
  end 

  def call
    greeting
    enter_zipcode
    zipcode = gets.strip
    valid_zipcode?(zipcode)
  end 

  def valid_zipcode?(zipcode)
    if zipcode.length == 5
      display_menu
      handle_menu_input(zipcode)
    else 
      puts "Invalid zipcode. Please enter valid zipcode >"
      zipcode = gets.strip
      valid_zipcode?(zipcode)    
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


