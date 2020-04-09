require_relative "./api.rb"

class Weather::CLI

  attr_accessor :zipcode, :forecast, :input

  def intialize 
    @zipcode = nil
    @forecast = nil
  end 

  def greeting
    puts "Welcome to Weather Today!\n\n"
  end 

  def enter_zipcode
    puts "Please enter your zipcode. >"
    @zipcode = gets.strip
  end 

  def call
    greeting
    enter_zipcode
    validate_zipcode 
  end 

  def valid_zipcode?
    zipcode.length == 5 && zipcode.to_i > 0

  end 
  
  def invalid_zipcode_response
    puts "Invalid zipcode."
    enter_zipcode
    validate_zipcode
  end 

  def validate_zipcode
    if valid_zipcode?
      get_forecast
    else 
      invalid_zipcode_response   
    end   
  end 

  def get_forecast
    forecast_response = Weather::API.get_forecast(zipcode)
    if forecast_response 
      @forecast = Weather::Forecast.new(
        forecast_response[:temp], 
        forecast_response[:feels_like], 
        forecast_response[:temp_min], 
        forecast_response[:temp_max], 
        forecast_response[:humidity]
      )
      display_menu
    else
      invalid_zipcode_response
    end 
  end 
  
  def display_menu
    puts "\nWhat would you like to see today?"
    puts "\n1. The temperature for today."
    puts "2. The highs and lows for today."
    puts "3. The humidity today."
    puts "4. Everything for today's forecast."
    puts "5. Exit"
    handle_menu_input
  end 

  

  def handle_menu_input
    input = gets.strip
    if input == "5" || input.downcase == "exit" 
      puts "\nGoodbye" 
    elsif (1..4).include?(input.to_i)
      print_forecast(input)
    else
      puts "\nInvalid option\n"
      display_menu
    end 
  end 

  def print_forecast(input)
    forecast.print_temperature if input == "1"
    forecast.print_temp_range if input == "2"
    forecast.print_humidity if input == "3"
    forecast.print_everything if input == "4" 
    display_menu
  end 

end 

