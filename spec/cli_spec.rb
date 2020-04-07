RSpec.describe CLI do

  describe "#call" do 
    cli = CLI.new
    zip = "75024"
    forecast = Forecast.new("76", "73", "65", "80", "45")
    
    before do 
      allow(API).to receive(:get_forecast).and_return(forecast)
      allow($stdout).to receive(:puts)      
      allow(cli).to receive(:gets).and_return("#{zip}\n")
    end 

    it "calls #greeting" do 
      expect(cli).to receive(:valid_zipcode?).with(zip)
      cli.call
    end

    it "calls #enter_zipcode" do 
      expect(cli).to receive(:valid_zipcode?).with(zip)
      cli.call
    end

    it "calls #valid_zipcode? with user input" do 
      expect(cli).to receive(:valid_zipcode?).with(zip)
      cli.call
    end

    # it "calls #display_menu if zipcode is valid" do 
    #   allow(cli).to receive(:valid_zipcode?).with(zip).and_return(true)
    #   expect(cli).to receive(:display_menu)
    #   cli.call
    # end 

    # it "does not call #display_menu if zipcode is invalid" do 
    #   allow(cli).to receive(:valid_zipcode?).with(zip).and_return(false)
    #   expect(cli).not_to receive(:display_menu)
    #   cli.call
    # end

    # it "calls #handle_menu_input if zipcode is valid" do 
    #   allow(cli).to receive(:valid_zipcode?).with(zip).and_return(true)
    #   allow(cli).to receive(:handle_menu_input)
    #   expect(cli).to receive(:handle_menu_input).with(zip)
    #   cli.call
    # end 
    
    # it "does not calls #handle_menu_input if zipcode is invalid" do 
    #   allow(cli).to receive(:valid_zipcode?).with(zip).and_return(false)
    #   expect(cli).not_to receive(:handle_menu_input)
    #   cli.call
    # end 
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

    before do 
      allow($stdout).to receive(:puts)      
    end 
    
    it "outputs a prompt" do
      cli = CLI.new
      output = capture_puts{ cli.enter_zipcode }
      expect(output).to include("Please enter your zipcode. > ")
    end 
  end

  fdescribe "#valid_zipcode?(zipcode)" do 
    cli = CLI.new
    zip = "75024"
    forecast = Forecast.new("76", "73", "65", "80", "45")
    
    before do 
      allow(API).to receive(:get_forecast).and_return(forecast)
      allow($stdout).to receive(:puts)      
      allow(cli).to receive(:gets).and_return("#{zip}\n")
      allow(cli).to receive(:display_menu)
      allow(cli).to receive(:handle_menu_input)
    end 

    it "calls #display_menu if zipcode is 5 digits" do
      expect(cli).to receive(:display_menu)
      cli.valid_zipcode?(zip)

    end 

    it "does not call #display_menu if zipcode is not 5 digits" do
      expect(cli).not_to receive(:display_menu)
      cli.valid_zipcode?("34353453453")
    end 

    it "calls #handle_menu_input(zipcode) if zipcode is 5 digits" do
      expect(cli).to receive(:handle_menu_input).with(zip)
      cli.valid_zipcode?(zip)
    end 

    it "does not call #handle_menu_input if zipcode is not 5 digits" do
      expect(cli).not_to receive(:handle_menu_input)
      cli.valid_zipcode?("32252534")
    end 

  end 

  describe "#display_menu" do 

    before do 
      allow($stdout).to receive(:puts)  
      allow(cli).to receive(:handle_menu_input)    
    end 

    it "outputs the menu option today's temperature" do 
      cli = CLI.new
      output = capture_puts{ cli.display_menu }
      expect(output).to include("1. The temperature for today.")
    end

    it "outputs the menu option for today's lows and highs" do 
      cli = CLI.new
      output = capture_puts{ cli.display_menu }
      expect(output).to include("2. The highs and lows for today.")
    end 

    it "outputs the menu option for today's humidity" do 
      cli = CLI.new
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

    it "calls #get_forecast after user selection" do 
      allow(cli).to receive(:gets).and_return("1")
      allow(API).to receive(:get_forecast).and_return(forecast)
      expect(API).to receive(:get_forecast).with(zip)
      cli.handle_menu_input(zip)
    end 
    
    it "calls #print_temperature if option 1." do 
      allow(cli).to receive(:gets).and_return("1")
      allow(API).to receive(:get_forecast).and_return(forecast)
      allow(forecast).to receive(:print_temperature)
      expect(forecast).to receive(:print_temperature)
      cli.handle_menu_input(zip)
    end

    it "calls #print_temp_range if option 2." do 
      allow(cli).to receive(:gets).and_return("2")
      allow(API).to receive(:get_forecast).and_return(forecast)
      allow(forecast).to receive(:print_temp_range)
      expect(forecast).to receive(:print_temp_range)
      cli.handle_menu_input(zip)
    end

    it "calls #print_humidity if option 3." do 
      allow(cli).to receive(:gets).and_return("3")
      allow(API).to receive(:get_forecast).and_return(forecast)
      allow(forecast).to receive(:print_humidity)
      expect(forecast).to receive(:print_humidity)
      cli.handle_menu_input(zip)
    end

    it "calls #print_everything if option 4." do 
      allow(cli).to receive(:gets).and_return("4")
      allow(API).to receive(:get_forecast).and_return(forecast)
      allow(forecast).to receive(:print_everything)
      expect(forecast).to receive(:print_everything)
      cli.handle_menu_input(zip)
    end
  end 

end