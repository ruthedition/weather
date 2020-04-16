class Weather::CLI

  attr_accessor :zipcode, :weather

  def intialize 
    @zipcode = nil
    @forecast = nil
  end 

  def start
    greeting
    main
  end 
  
  def greeting
    puts "Welcome to Weather Today!\n\n"
  end 

  def main
    enter_zipcode
    if zipcode == "exit"
      puts "\nGoodbye"
    elsif valid_zipcode?
      weather_or_forecast
    else 
      puts "Invalid zipcode." 
      main
    end
  end 

  def enter_zipcode
      puts "Please enter your zipcode or type 'exit' to leave. >"
      @zipcode = gets.strip
  end 

  def valid_zipcode?
    zipcode.delete('^0-9').length == 5 && zipcode.to_i > 0
  end 

  def weather_or_forecast
    puts "\nWould you like to see the weather for today or a 5 day forecast? Please select a number or 'exit' to leave."
    puts "\n1. Today's weather"
    puts "2. 5 day forecast"
    input = gets.strip.downcase
    if input == "exit"
      puts "\nGoodbye"
    elsif input == "1"
      get_weather
    elsif input == "2"
      get_forecast
    else 
      puts "\nInvalid option\n"
      weather_or_forecast
    end
  end 

  def get_weather
    weather_response = Weather::API.get_weather(zipcode)
    if weather_response 
      Weather::Forecast.all.clear
      @weather = Weather::Forecast.create(weather_response)
      puts "\nWeather forecast options for #{weather.date}:"
      weather_menu
    else
      puts "Invalid zipcode." 
      main
    end 
  end 
  
  def weather_menu
    puts "\n1. The temperature"
    puts "2. The highs and lows"
    puts "3. The humidity"
    puts "4. Everything for #{weather.date}"
    puts "5. Exit"
    handle_weather_menu_input
  end 

  def get_forecast
    forecast_responses = Weather::API.get_forecast(zipcode)
    if forecast_responses
      Weather::Forecast.all.clear
      forecast_responses.each { |forecast_response| Weather::Forecast.create(forecast_response) } 
      forecast_menu 
    else 
      puts "Invalid zipcode."
      main 
    end 
  end 

  def forecast_menu
    puts "\nWhat day would you like to see?\n\n"
    Weather::Forecast.all.each.with_index(1) { |forecast, index| puts "#{index}. #{forecast.date}" }
    puts "\nPlease type '0' for the whole week or 'exit' to leave."
    handle_forecast_menu_input
  end 

  def handle_forecast_menu_input
    input = gets.strip
    if input.downcase == "exit" 
      puts "\nGoodbye" 
    elsif input.length == 1 && (1..6).include?(input.to_i)
      index = input.to_i - 1
      @weather = Weather::Forecast.all[index]
      puts "\nSelect what you would like to see for #{weather.date}"
      weather_menu
    elsif input == "0"
      Weather::Forecast.week_forecast
      puts "\nThat's the weather for this week! Would you like to exit? (y/n)"
      input = gets.strip.downcase
      if input == "y" || input == "yes" || input == "exit"
        puts "\nGoodbye"
      else 
        weather_or_forecast
      end 
    else
      puts "\nInvalid option\n"
      forecast_menu
    end 
  end 

  def handle_weather_menu_input
    input = gets.strip
    if input == "5" || input.downcase == "exit" 
      puts "\nGoodbye" 
    elsif input.length == 1 && (1..4).include?(input.to_i)
      print_weather(input)
    else
      puts "\nInvalid option\n"
      weather_menu
    end 
  end 

  def print_weather(input)
    if (1..3).include?(input.to_i)
      weather.print_temperature if input == "1"
      weather.print_temp_range if input == "2"
      weather.print_humidity if input == "3"
      puts "\nWould you like to see anything else?"
      weather_menu
    else    
      weather.print_everything if input == "4" 
      puts "That's the weather for #{weather.date}! Would you like to exit? (y/n)"
      input = gets.strip.downcase
      if input == "y" || input == "yes" || input == "exit"
        puts "\nGoodbye"
      else 
        weather_or_forecast
      end 
    end 
  end 

end 

