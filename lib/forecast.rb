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
      puts "               #{self.all[0].date} | #{self.all[1].date} | #{self.all[2].date} | #{self.all[3].date} | #{self.all[4].date}"
      puts "               -------------------------------------------------------------------------------------------------------------------------------"
      puts " Temperature:  |          #{self.all[0].temperature}         |         #{self.all[1].temperature}          |         #{self.all[2].temperature}            |         #{self.all[3].temperature}          |         #{self.all[4].temperature}         |"
      puts " Feels Like:   |          #{self.all[0].feels_like}         |         #{self.all[1].feels_like}          |         #{self.all[2].feels_like}            |         #{self.all[3].feels_like}          |         #{self.all[4].feels_like}         |"
      puts " High:         |          #{self.all[0].highest_temperature}         |         #{self.all[1].highest_temperature}          |         #{self.all[2].highest_temperature}            |         #{self.all[3].highest_temperature}          |         #{self.all[4].highest_temperature}         |"
      puts " Low:          |          #{self.all[0].lowest_temperature}         |         #{self.all[1].lowest_temperature}          |         #{self.all[2].lowest_temperature}            |         #{self.all[3].lowest_temperature}          |         #{self.all[4].lowest_temperature}         |"
      puts " Humidity:     |          #{self.all[0].humidity}         |         #{self.all[1].humidity}          |         #{self.all[2].humidity}            |         #{self.all[3].humidity}          |         #{self.all[4].humidity}         |"
      puts "               -------------------------------------------------------------------------------------------------------------------------------"
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