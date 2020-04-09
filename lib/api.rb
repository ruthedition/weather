require 'httparty'
require_relative "./forecast"
require 'json'

class Weather::API

  BASE_URL = "https://api.openweathermap.org/data/2.5/weather"

  def self.get_forecast(zipcode)
    response = call_api(zipcode)
    if response[:main]
      response[:main]
    else
      puts response[:message]
    end
  end 

  def self.call_api(zipcode)
    params = {zip: zipcode, appid: ENV["API_KEY"], units: "imperial"}
    response = HTTParty.get(BASE_URL, query: params)
    JSON.parse(response.body, symbolize_names: true)
 end 

end




