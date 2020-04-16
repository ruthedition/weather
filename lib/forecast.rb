class Weather::Forecast

  attr_reader :temperature, :feels_like, :lowest_temperature, :highest_temperature, :humidity, :date

  @@all = [ ]
  def initialize(temperature, feels_like, lowest_temperature, highest_temperature, humidity, date)
    @temperature = temperature 
    @feels_like = feels_like
    @lowest_temperature = lowest_temperature
    @highest_temperature = highest_temperature
    @humidity = humidity 
    @date = date
    @@all << self
  end

  def self.all
    @@all
  end 

  def self.create(response)
    self.new(
      response[:temp], 
      response[:feels_like], 
      response[:temp_min], 
      response[:temp_max], 
      response[:humidity],
      response[:date]
    )
  end 

  def self.week_forecast
    tp @@all 
  end

  def self.coldest_day
    @@all.sort { |current, n | current.temperature <=> n.temperature }.first
  end 


  def print_temperature
    puts "\nThe temperature #{date.split(",").first} is #{temperature}, but it feels like #{feels_like}.\n\n"
  end 

  def print_temp_range
    puts "\nThe low for #{date.split(",").first} is #{lowest_temperature}, and the high #{date.split(",").first} is #{highest_temperature}.\n\n"
  end 

  def print_humidity
    puts "\nThe humidity #{date.split(",").first} is #{humidity}.\n\n"
  end 

  def print_everything
    self.print_temperature
    self.print_temp_range
    self.print_humidity
  end 

end 