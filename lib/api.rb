require 'httparty'
require 'json'

class Weather::API

  BASE_URL = "https://api.openweathermap.org/data/2.5"

  def self.get_weather(zipcode)
    response = call_api(zipcode, "weather")
    if response[:main]
      response[:main][:date]="today"
      response[:main]
    else
      puts response[:message]
    end
  end 

  def self.call_api(zipcode, endpoint)
    params = {zip: zipcode, appid: ENV["API_KEY"], units: "imperial"}
    response = HTTParty.get("#{BASE_URL}/#{endpoint}", query: params)
    JSON.parse(response.body, symbolize_names: true)
  end 
 
  def self.get_forecast(zipcode)
    response = call_api(zipcode, "forecast")
    if response[:list]
      dates(response[:list]).map do |date, date_values|
        day_avg = days_avg(date_values)
        day_avg[:date] = date
        day_avg
      end
    else
      puts response[:message]
    end 
  end

  def self.dates(response_list)
    dates_hash = { }
    
    response_list.each do |item|
      date = Time.at(item[:dt]).strftime("%A, %B %d, %Y")
      item[:main][:date] = date 

      if !dates_hash[date] 
        dates_hash[date] = {temps: [], feels: [], highs: [], lows: [], humidities: []}
      end 

      dates_hash[date][:temps] << item[:main][:temp]
      dates_hash[date][:feels] << item[:main][:feels_like]
      dates_hash[date][:highs] << item[:main][:temp_max]
      dates_hash[date][:lows] << item[:main][:temp_min]
      dates_hash[date][:humidities] << item[:main][:humidity]
    end 
    dates_hash
  end 

  def self.days_avg(date_values) 
    {
      temp: "%.2f" % average(date_values[:temps]), 
      feels_like: "%.2f" % average(date_values[:feels]), 
      temp_min: "%.2f" % average(date_values[:highs]), 
      temp_max: "%.2f" % average(date_values[:lows]), 
      humidity: "%.2f" % average(date_values[:humidities])
    }
  end 

  def self.average(array)
    array.reduce(:+) / array.size
  end 
end