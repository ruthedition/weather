RSpec.describe CLI do

  describe "#call" do 
    cli = CLI.new
    zip = "75024"
    
    before do 
      allow($stdout).to receive(:puts)      
      allow(cli).to receive(:gets).and_return("#{zip}\n")
    end 

    it "outputs a greeting" do
      output = capture_puts{ cli.call }
      expect(output).to include("Welcome to Weather Today")
    end

    it "outputs a prompt" do
      output = capture_puts{ cli.call }
      expect(output).to include("Please enter a zip code for the forecast in that area > ")
    end 

    it "calls #valid_zipcode? with user input" do 
      expect(cli).to receive(:valid_zipcode?).with(zip)
      cli.call
    end

    it "calls #get_weather if zipcode is valid" do 
      allow(cli).to receive(:valid_zipcode?).with(zip).and_return(true)
      expect(cli).to receive(:get_weather).with(zip)
      cli.call
    end 

    it "does not call #get_weather if zipcode is not valid" do 
      allow(cli).to receive(:valid_zipcode?).with(zip).and_return(false)
      expect(cli).not_to receive(:get_weather)
      cli.call
    end 

  end 

  describe "#valid_zipcode" do 
    cli = CLI.new
    zip = "75024"

    it "returns true if zipcode is not longer than 5 digits" do
      expect(cli.valid_zipcode?(zip)).to eq(true)
    end 

    it "returns false if zipcode is longer than 5 digits" do
      expect(cli.valid_zipcode?("2940912121")).to eq(false)
    end 

    it "returns false if zipcode is less than 5 digits" do
      expect(cli.valid_zipcode?("2")).to eq(false)
    end 
  end 

  describe "#get_weather" do 
    cli = CLI.new
    forecast = Forecast.new
    zip = 75035

    it "outputs the current temperature and what it feels like " do 
      output = capture_puts{ cli.get_weather }
      allow(API).to receive(:get_forecast).with(zip).and_return(forecast)
      expect(output).to include("The temperature today is 76, but it feels like 73.")
    end 
  end 


end