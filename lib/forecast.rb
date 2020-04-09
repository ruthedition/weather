require './lib/api'

class Weather::Forecast

  attr_reader :temperature, :feels_like, :lowest_temperature, :highest_temperature, :humidity

  def initialize(temperature, feels_like, lowest_temperature, highest_temperature, humidity)
    @temperature = temperature 
    @feels_like = feels_like
    @lowest_temperature = lowest_temperature
    @highest_temperature = highest_temperature
    @humidity = humidity 
  end

  def print_temperature
    puts "The temperature today is #{temperature}, but it feels like #{feels_like}.\n\n"
  end 

  def print_temp_range
    puts "\nThe low for today is #{lowest_temperature}, and the high today is #{highest_temperature}.\n\n"
  end 

  def print_humidity
    puts "\nThe humidity today is #{humidity}.\n\n"
  end 

  def print_everything
    self.print_temperature
    self.print_temp_range
    self.print_humidity
  end 

end 