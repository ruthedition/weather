RSpec.describe Weather::CLI do

  describe "#call" do 
    cli = Weather::CLI.new
    zip = "75024"
    forecast = Weather::Forecast.new("76", "73", "65", "80", "45")
    
    before do 
      allow($stdout).to receive(:puts)    
      allow(cli).to receive(:greeting)  
      allow(cli).to receive(:enter_zipcode).and_return(zip)
      allow(cli).to receive(:validate_zipcode)
      allow(cli).to receive(:display_menu)
      allow(cli).to receive(:handle_menu_input)
    end 

    it "calls #greeting" do 
      allow(cli).to receive(:greeting)  
      expect(cli).to receive(:greeting)
      cli.call
    end

    it "calls #enter_zipcode" do 
      expect(cli).to receive(:enter_zipcode)
      cli.call
    end

    it "calls #validate_zipcode" do 
      expect(cli).to receive(:validate_zipcode)
      cli.call
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

  describe "#enter_zipcode" do
    cli = Weather::CLI.new
    
    before do 
      allow($stdout).to receive(:puts)  
      allow(cli).to receive(:gets).and_return("zip")    
    end 
    
    it "outputs a prompt" do
      output = capture_puts{ cli.enter_zipcode }
      expect(output).to include("Please enter your zipcode. >")
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

    # it "returns false if zipcode has letters" do 
    #   cli.zipcode = "23sd2"
    #   expect(cli.valid_zipcode?).to eq(false)
    # end

  end 

  describe "#invalid_zipcode_response" do 
    cli = Weather::CLI.new
    zip = "75024"
    
    before do 
      allow($stdout).to receive(:puts)  
      allow(cli).to receive(:enter_zipcode).and_return(zip)    
      allow(cli).to receive(:validate_zipcode)
    end


    it "outputs warning zipcode is invalid, and asks for zipcode again" do
      output = capture_puts{ cli.invalid_zipcode_response }
      expect(output).to eq("Invalid zipcode.\n")
    end 

    it "calls #enter_zipcode for new zipcode" do
      expect(cli).to receive(:enter_zipcode)
      cli.invalid_zipcode_response
    end 

    it "calls #valid_zipcode? with user input" do
      expect(cli).to receive(:validate_zipcode)
      cli.invalid_zipcode_response
    end 
  end 

  describe "#validate_zipcode" do
    cli = Weather::CLI.new
    zipcode = "75024"
    cli.zipcode = zipcode
    
    before do 
      allow($stdout).to receive(:puts)  
      allow(cli).to receive(:gets)
      allow(cli).to receive(:enter_zipcode)    
      allow(cli).to receive(:valid_zipcode?)
      allow(cli).to receive(:display_menu)
      allow(cli).to receive(:invalid_zipcode_response)
    end

    it "calls #valid_zipcode? with user input" do 
      expect(cli).to receive(:valid_zipcode?)
      cli.validate_zipcode
    end

    it "calls #display_menu if zipcode is valid" do 
      allow(cli).to receive(:valid_zipcode?).and_return(true)
      expect(cli).to receive(:display_menu)
      cli.validate_zipcode
    end 

    it "does not call #display_menu if zipcode is invalid" do 
      allow(cli).to receive(:valid_zipcode?).and_return(false)
      expect(cli).not_to receive(:display_menu)
      cli.validate_zipcode
    end

    it "calls #invalid_zipcode_response if zipcode is invalid" do 
      allow(cli).to receive(:valid_zipcode?).and_return(false)
      expect(cli).to receive(:invalid_zipcode_response)
      cli.validate_zipcode
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

    it "calls #get_forecast" do 
      expect(cli).to receive(:get_forecast)
      cli.display_menu
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

    it "calls #print_temperature if option 1." do 
      allow(forecast).to receive(:print_temperature)
      expect(forecast).to receive(:print_temperature)
      cli.print_forecast("1")
    end

    it "calls #print_temp_range if option 2." do 
      allow(forecast).to receive(:print_temp_range)
      expect(forecast).to receive(:print_temp_range)
      cli.print_forecast("2")
    end

    it "calls #print_humidity if option 3." do 
      allow(forecast).to receive(:print_humidity)
      expect(forecast).to receive(:print_humidity)
      cli.print_forecast("3")
    end

    it "calls #print_everything if option 4." do 
      allow(forecast).to receive(:print_everything)
      expect(forecast).to receive(:print_everything)
      cli.print_forecast("4")
    end 
  end 

end
