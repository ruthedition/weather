class Forecast

  attr_reader :temperature, :feels_like, :lowest_temperature, :highest_temperature, :humidity

    def initialize(temperature, feels_like, lowest_temperature, highest_temperature, humidity)
      @temperature = temperature 
      @feels_like = feels_like
      @lowest_temperature = lowest_temperature
      @highest_temperature = highest_temperature
      @humidity = humidity 
    end

end 