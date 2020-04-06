require 'httparty'
require_relative "./forecast"
require 'json'

class API

  BASE_URL = "https://api.openweathermap.org/data/2.5/weather"

  def self.get_forecast(zipcode)
    response = weather_format(zipcode)
    return Forecast.new(response[:temp], response[:feels_like], response[:temp_min], response[:temp_max], response[:humidity])
  end 

  def self.weather_format(zipcode)
    params = {zip: zipcode, appid: ENV["API_KEY"], units: "imperial"}
    response = HTTParty.get(BASE_URL, query: params)
    JSON.parse(response.body, symbolize_names: true)[:main]
  end 
end




