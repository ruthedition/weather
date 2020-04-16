RSpec.describe Weather::CLI do

  describe "#start" do 
    cli = Weather::CLI.new
    
    before do 
      allow($stdout).to receive(:puts)    
      allow(cli).to receive(:greeting)
      allow(cli).to receive(:gets)
      allow(cli).to receive(:main)
    end 
 
    it "calls #greeting" do 
      allow(cli).to receive(:greeting)  
      expect(cli).to receive(:greeting)
      cli.start
    end

    it "calls #main" do 
      allow(cli).to receive(:main)  
      expect(cli).to receive(:main)
      cli.start
    end 
  end 

  describe "#greeting" do 

    before do 
      allow($stdout).to receive(:puts)      
    end 
    
    it "outputs a greeting" do
      cli = Weather::CLI.new
      output = capture_puts{ cli.greeting }
      expect(output).to include("Welcome to Weather Today")
    end

  end 

  describe "#main" do 
    cli = Weather::CLI.new
    zipcode = "75024"
    cli.zipcode = zipcode
    forecast = Weather::Forecast.new("76", "73", "65", "80", "45")

    before do 
      allow($stdout).to receive(:puts) 
      allow(cli).to receive(:enter_zipcode)
      allow(cli).to receive(:valid_zipcode?).and_return(true)
      allow(cli).to receive(:display_menu)
      allow(cli).to receive(:get_forecast)
    end 
 
    it "calls #enter_zipcode" do 
      expect(cli).to receive(:enter_zipcode)
      cli.main
    end

    it "exits program" do
      exit_cli = Weather::CLI.new
      exit_cli.zipcode = "exit" 
      expect(exit_cli).to receive(:enter_zipcode)
      output = capture_puts{ exit_cli.main }
      expect(output).to eq("\nGoodbye\n")
    end  

    it "calls #valid_zipcode? with user input" do 
      expect(cli).to receive(:valid_zipcode?)
      cli.main
    end 

    it "outputs invalid response if zipcode is invalid" do
      allow(cli).to receive(:valid_zipcode?).and_return(false,true)
      output = capture_puts{ cli.main }
      expect(output).to eq("Invalid zipcode.\n")
    end  
  end 

  describe "#enter_zipcode" do
    cli = Weather::CLI.new
    
    before do 
      allow($stdout).to receive(:puts)  
      allow(cli).to receive(:gets).and_return("zip")    
    end 
    
    it "outputs a prompt" do
      output = capture_puts{ cli.enter_zipcode }
      expect(output).to include("Please enter your zipcode or type 'exit' to leave. >")
    end 

    it "returns user input" do
      expect(cli.enter_zipcode).to eq("zip")
    end 

  end

  describe "#valid_zipcode?" do 
    cli = Weather::CLI.new
    zipcode = "75028"
    cli.zipcode = zipcode

    it "returns true if zipcode is equal to 5 digits" do 
      expect(cli.valid_zipcode?).to eq(true)
    end 

    it "returns false if zipcode is less than 5 digits" do 
      cli.zipcode = "1"
      expect(cli.valid_zipcode?).to eq(false)
    end 

    it "returns false if zipcode is more than 5 digits" do 
      cli.zipcode = "3456776777"
      expect(cli.valid_zipcode?).to eq(false)
    end

    it "returns false if zipcode is more than 0" do 
      cli.zipcode = "00000"
      expect(cli.valid_zipcode?).to eq(false)
    end

  end 

  describe "#get_forecast" do 
    cli = Weather::CLI.new
    forecast_response = {
      temp: 282.55,
      feels_like: 281.86,
      temp_min: 280.37,
      temp_max: 284.26,
      humidity: 100
    }
   
    before do 
      allow($stdout).to receive(:puts)  
      allow(Weather::API).to receive(:get_forecast).and_return(forecast_response)
      allow(cli).to receive(:display_menu) 
      allow(cli).to receive(:main)
    end 

    it "calls API.get_forecast" do 
      expect(Weather::API).to receive(:get_forecast)
      cli.get_forecast
    end 

    it "creates a forecast instance if API.get_forecast is valid" do
      cli.get_forecast
      expect(cli.forecast).to be_instance_of(Weather::Forecast)
    end 

    it "outputs weather forecast options for today" do
      output = capture_puts{ cli.get_forecast }
      expect(output).to eq("\nWeather forecast options for today:\n")
    end 

    it "calls #display_menu" do 
      expect(cli).to receive(:display_menu)
      cli.get_forecast
    end 

    it "outputs invalid response if forecast is nil" do 
      allow(Weather::API).to receive(:get_forecast)
      output = capture_puts{ cli.get_forecast }
      expect(output).to eq("Invalid zipcode.\n")
    end  

    it "calls #main if forecast is nil" do 
      allow(Weather::API).to receive(:get_forecast)
      expect(cli).to receive(:main)
      cli.get_forecast
    end  
    
  end 

  describe "#display_menu" do 
    cli = Weather::CLI.new

    before do 
      allow($stdout).to receive(:puts) 
      allow(cli).to receive(:gets)
      allow(cli).to receive(:handle_menu_input)  
      allow(cli).to receive(:get_forecast)  
    end 
    
    it "outputs the menu option today's temperature" do 
      output = capture_puts{ cli.display_menu }
      expect(output).to include("1. The temperature for today.")
    end

    it "outputs the menu option for today's lows and highs" do 
      output = capture_puts{ cli.display_menu }
      expect(output).to include("2. The highs and lows for today.")
    end 

    it "outputs the menu option for today's humidity" do 
      output = capture_puts{ cli.display_menu }
      expect(output).to include("3. The humidity today.")
    end 

    it "outputs the menu option for everything about the weather today" do 
      output = capture_puts{ cli.display_menu }
      expect(output).to include("4. Everything for today's forecast.")
    end 

    it "outputs the option to leave" do 
      output = capture_puts{ cli.display_menu }
      expect(output).to include("5. Exit")
    end 

    it "calls #handle_menu_input" do 
      expect(cli).to receive(:handle_menu_input)
      cli.display_menu
    end 

  end 
  
  describe "#handle_menu_input" do
    cli = Weather::CLI.new
    forecast = Weather::Forecast.new("76", "73", "65", "80", "45")
    cli.forecast = forecast

    before do 
      allow($stdout).to receive(:puts)
      allow(Weather::API).to receive(:get_forecast).and_return(forecast)
      allow(cli).to receive(:gets).and_return("1\n","5\n")
      allow(cli).to receive(:display_menu)
    end 

    it "calls #print_forecast after user selection is from 1-4" do 
      allow(cli).to receive(:print_forecast).with("1")
      expect(cli).to receive(:print_forecast).with("1")
      cli.handle_menu_input
    end 

    it "calls #display_menu after user selection is from 1-4" do 
      expect(cli).to receive(:display_menu)
      cli.handle_menu_input
    end 

    it "outputs a closing when user selects 5" do 
      allow(cli).to receive(:gets).and_return("5\n")
      output = capture_puts{ cli.handle_menu_input }
      expect(output).to eq("\nGoodbye\n")
    end

    it "outputs a closing when user enters exit" do 
      allow(cli).to receive(:gets).and_return("exit\n")
      output = capture_puts{ cli.handle_menu_input }
      expect(output).to eq("\nGoodbye\n")
    end 

    it "outputs error if user input is not valid" do
      allow(cli).to receive(:gets).and_return("something invalid\n","5\n")
      output = capture_puts{ cli.handle_menu_input }
      expect(output).to eq("\nInvalid option\n")    
    end 
  end 

  describe "#print_forecast" do
    cli = Weather::CLI.new
    forecast = Weather::Forecast.new("76", "73", "65", "80", "45")
    cli.forecast = forecast

    before do
      allow($stdout).to receive(:puts)
      allow(cli).to receive(:gets)
      allow(cli).to receive(:display_menu)
      allow(forecast).to receive(:print_temperature)
      allow(forecast).to receive(:print_temp_range)
      allow(forecast).to receive(:print_humidity)
      allow(forecast).to receive(:print_everything)
    end 

    it "calls #print_temperature if option 1." do 
      expect(forecast).to receive(:print_temperature)
      cli.print_forecast("1")
    end

    it "calls #print_temp_range if option 2." do 
      expect(forecast).to receive(:print_temp_range)
      cli.print_forecast("2")
    end

    it "calls #print_humidity if option 3." do 
      expect(forecast).to receive(:print_humidity)
      cli.print_forecast("3")
    end

    it "outputs if user wants more information" do
      output = capture_puts{ cli.print_forecast("2") }
      expect(output).to eq("\nWould you like to see anything else?\n")    
    end 

    it "calls #display_menu if user wants to see more" do
      expect(cli).to receive(:display_menu)
      cli.print_forecast("2") 
    end 

    it "calls #print_everything if option 4." do 
      allow(cli).to receive(:gets).and_return("4")
      expect(forecast).to receive(:print_everything)
      cli.print_forecast("4")
    end 

    it "outputs if user has seen all options" do
      allow(cli).to receive(:gets).and_return("4")
      output = capture_puts{ cli.print_forecast("4") }
      expect(output).to eq("That's the weather for today! Would you like to exit? (y/n)\n")    
    end 

    it "outputs a closing when user selects y" do 
      allow(cli).to receive(:gets).and_return("y")
      output = capture_puts{ cli.print_forecast("y") }
      expect(output).to include("\nGoodbye")    
    end

    it "calls #display_menu if user does not want to exit" do
      allow(cli).to receive(:gets).and_return("n")
      expect(cli).to receive(:display_menu)
      cli.print_forecast("n") 
    end 
  end 

end
