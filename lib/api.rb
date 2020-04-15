require 'httparty'
require 'json'

class Weather::API

  BASE_URL = "https://api.openweathermap.org/data/2.5"

  def self.get_weather(zipcode)
    response = call_api(zipcode)
    if response[:main]
      response[:main]
    else
      puts response[:message]
    end
  end 

  def self.call_api(zipcode)
    params = {zip: zipcode, appid: ENV["API_KEY"], units: "imperial"}
    response = HTTParty.get(BASE_URL + "/weather", query: params)
    JSON.parse(response.body, symbolize_names: true)
 end 

end


# https://api.openweathermap.org/data/2.5/forecast?zip=75035&units=imperial&appid=30eea60e74dda9ca8068a04a3a3dafaf

