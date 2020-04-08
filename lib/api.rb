require 'httparty'
require_relative "./forecast"
require 'json'

class Weather::API

  BASE_URL = "https://api.openweathermap.org/data/2.5/weather"

  def self.get_forecast(zipcode)
    # Weather::Forecast.new(response[:temp], response[:feels_like], response[:temp_min], response[:temp_max], response[:humidity])
   
    params = {zip: zipcode, appid: ENV["API_KEY"], units: "imperial"}
    response = HTTParty.get(BASE_URL, query: params)
    if response["main"]
      JSON.parse(response.body, symbolize_names: true)[:main]
    else
      puts response["message"]
    end


  end 

end




