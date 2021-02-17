class Weather::PrintConfig

  def self.table_config
    tp.set Weather::Forecast, 
    :date, 
    {temperature: {display_name: "temp"}}, 
    {feels_like: {display_name: "feels like"}}, 
    {highest_temperature: {display_name: "highs"}}, 
    {lowest_temperature: {display_name: "lows"}}, 
    :humidity
  end
end 