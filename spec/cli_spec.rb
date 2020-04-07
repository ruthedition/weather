RSpec.describe CLI do

  describe "#call" do 
    cli = CLI.new
    zip = "75024"
    forecast = Forecast.new("76", "73", "65", "80", "45")
    
    before do 
      allow(API).to receive(:get_forecast).and_return(forecast)
      allow($stdout).to receive(:puts)      
      allow(cli).to receive(:enter_zipcode).and_return(zip)
      allow(cli).to receive(:valid_zipcode?).with(zip).and_return(true)
      allow(cli).to receive(:display_menu)
      allow(cli).to receive(:handle_menu_input)
    end 

    it "calls #greeting" do 
      expect(cli).to receive(:greeting)
      cli.call
    end

    it "calls #enter_zipcode" do 
      expect(cli).to receive(:enter_zipcode)
      cli.call
    end

    it "calls #valid_zipcode? with user input" do 
      expect(cli).to receive(:valid_zipcode?).with(zip)
      cli.call
    end

    it "calls #display_menu if zipcode is valid" do 
      expect(cli).to receive(:display_menu)
      cli.call
    end 

    it "does not call #display_menu if zipcode is invalid" do 
      allow(cli).to receive(:valid_zipcode?).with(zip).and_return(false)
      expect(cli).not_to receive(:display_menu)
      cli.call
    end

    it "calls #handle_menu_input if zipcode is valid" do 
      expect(cli).to receive(:handle_menu_input).with(zip)
      cli.call
    end 
    
    it "does not calls #handle_menu_input if zipcode is invalid" do 
      allow(cli).to receive(:valid_zipcode?).with(zip).and_return(false)
      expect(cli).not_to receive(:handle_menu_input)
      cli.call
    end 

    it "calls #invalid_zipcode_response if zipcode is invalid" do 
      allow(cli).to receive(:valid_zipcode?).with(zip).and_return(false)
      expect(cli).to receive(:invalid_zipcode_response)
      cli.call
    end 
  end 

  describe "#greeting" do 

    before do 
      allow($stdout).to receive(:puts)      
    end 
    
    it "outputs a greeting" do
      cli = CLI.new
      output = capture_puts{ cli.greeting }
      expect(output).to include("Welcome to Weather Today")
    end
  end 

  describe "#enter_zipcode" do
    cli = CLI.new
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

  describe "#valid_zipcode?(zipcode)" do 
    cli = CLI.new
    zip = "75024"
    
    it "checks if zipcode is equal to 5 digits" do 
      allow(cli).to receive(:gets).and_return("#{zip}\n")
      expect(
      
    end 
    
    # it "calls #display_menu if zipcode is 5 digits" do
    #   expect(cli).to receive(:display_menu)
    #   cli.valid_zipcode?(zip)

    # end 

    # it "does not call #display_menu if zipcode is not 5 digits" do
    #   expect(cli).not_to receive(:display_menu)
    #   cli.valid_zipcode?("34353453453")
    # end 

    # it "calls #handle_menu_input(zipcode) if zipcode is 5 digits" do
    #   expect(cli).to receive(:handle_menu_input).with(zip)
    #   cli.valid_zipcode?(zip)
    # end 

    # it "does not call #handle_menu_input if zipcode is not 5 digits" do
    #   expect(cli).not_to receive(:handle_menu_input)
    #   cli.valid_zipcode?("32252534")
    # end 
  end 

  describe "#invalid_zipcode_response" do 
    cli = CLI.new
    zip = "75024"
    output = capture_puts{ cli.invalid_zipcode_response }
    
    before do 
      allow($stdout).to receive(:puts)  
      allow(cli).to receive(:gets).and_return(zip)
      allow(cli).to receive(:enter_zipcode)    
      allow(cli).to receive(:valid_zipcode?)
    end


    it "outputs warning zipcode is invalid, and asks for zipcode again" do
      output = capture_puts{ cli.invalid_zipcode_response }
      expect(output).to eq("Invalid zipcode. Please enter your zipcode.\n")
    end 

    it "calls #enter_zipcode for new zipcode" do
      expect(cli).to receive(:enter_zipcode)
      cli.enter_zipcode
    end 

    it "calls #valid_zipcode? with user input" do
      expect(cli).to receive(:valid_zipcode?).with(zip)
      cli.valid_zipcode?(zip)
    end 
  end 

  describe "#display_menu" do 
    cli = CLI.new

    before do 
      allow($stdout).to receive(:puts)  
      allow(cli).to receive(:handle_menu_input)    
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
      cli = CLI.new
      output = capture_puts{ cli.display_menu }
      expect(output).to include("4. Everything for today's forecast.")
    end 
  end 
  
  describe "#handle_menu_input" do
    cli = CLI.new
    forecast = Forecast.new("76", "73", "65", "80", "45")
    zip = "75024"

    before do 
      allow($stdout).to receive(:puts)
      allow(API).to receive(:get_forecast).and_return(forecast)
    end 

    it "calls #get_forecast after user selection" do 
      allow(cli).to receive(:gets).and_return("1","5")
      expect(API).to receive(:get_forecast).with(zip)
      cli.handle_menu_input(zip)
    end 
    
    it "calls #print_temperature if option 1." do 
      allow(cli).to receive(:gets).and_return("1","5")
      allow(forecast).to receive(:print_temperature)
      expect(forecast).to receive(:print_temperature)
      cli.handle_menu_input(zip)
    end

    it "calls #print_temp_range if option 2." do 
      allow(cli).to receive(:gets).and_return("2","5")
      allow(forecast).to receive(:print_temp_range)
      expect(forecast).to receive(:print_temp_range)
      cli.handle_menu_input(zip)
    end

    it "calls #print_humidity if option 3." do 
      allow(cli).to receive(:gets).and_return("3","5")
      allow(forecast).to receive(:print_humidity)
      expect(forecast).to receive(:print_humidity)
      cli.handle_menu_input(zip)
    end

    it "calls #print_everything if option 4." do 
      allow(cli).to receive(:gets).and_return("4","5")
      allow(forecast).to receive(:print_everything)
      expect(forecast).to receive(:print_everything)
      cli.handle_menu_input(zip)
    end

    it "outputs a closing" do 
      allow(cli).to receive(:gets).and_return("5")
      output = capture_puts{ cli.handle_menu_input(zip) }
      expect(output).to eq("Goodbye\n")
    end
  end 

end