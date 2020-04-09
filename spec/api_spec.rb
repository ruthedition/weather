RSpec.describe Weather::API do

  describe "#get_forecast" do 

    it "returns a forecast from the API" do 
      response_body = {"main":
        {
          temp: 282.55,
          feels_like: 281.86,
          temp_min: 280.37,
          temp_max: 284.26,
          humidity: 100
        }
      }
      allow(Weather::API).to receive(:call_api).and_return(response_body)
      response = Weather::API.get_forecast("75024")
      expect(response[:temp]).to eq(282.55)
    end 
  end 
  
end 