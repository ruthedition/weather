require 'httparty'
require 'pry'

class API

  BASE_URL = "https://api.openweathermap.org/data/2.5/weather"

  def self.get_forecast(zipcode)
    params = {zip: zipcode, appid: ENV["API_KEY"], units: "imperial"}
    response = HTTParty.get(BASE_URL, query: params)
    return response["main"]
  end 

end




