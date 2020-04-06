RSpec.describe API do

  describe "#get_forecast" do 

    it "returns a forecast from the API" do 
      response_body = {
        temp: 282.55,
        feels_like: 281.86,
        temp_min: 280.37,
        temp_max: 284.26,
        humidity: 100
      }
      allow(API).to receive(:weather_format).and_return(response_body)
      forecast = API.get_forecast("75024")
      expect(forecast.temperature).to eq(282.55)
    end 

  end 
  
end 