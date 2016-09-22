require 'geocoder' #Gem to get the longitude and latitude values
require 'faker' #Gem to generate fake data
class WeatherSimulator

  def initialize
    puts " Type YES to enter city names manualy or Type NO for automatic simulation"
    @test_type = gets.chomp
  end

  def start_simulation
    if @test_type.match(/yes/)
       puts "Type the multiple city names with space seperator"
       gets.chomp.split.each do | city |
       manual_simulation(city)
       end
    elsif @test_type.match(/no/)
       auto_simulation
    else
      puts "Please type only yes or no to continue"
    end
  end

  private
  def manual_simulation(city = nil)
      gdata = Geocoder.search(city)
      lat, lng = gdata[0].data["geometry"]["location"].values
      temp,wcond =calc_temp(lat,lng)
      time = calc_time(lat, lng)
      puts "#{city}|#{lat},#{lng},#{rand(1..1000)}|#{time}|#{wcond}|#{temp}|#{Faker::Number.decimal(2)}|#{rand(1..95)}"
  end

  def auto_simulation
      city_list = ["Brisbane", "London", "Paris", "Beijing", "Dubai", "Darwin", "Rome", "Capetown","Newyork","Bangalore","Ottawa"]
      city_list.each do | city |
          manual_simulation(city)
     end
  end

  def calc_temp(lat,lng)
    ftemp= lat.abs<20 ? (80 - (0.0026 * 66)) : (lat.abs>20 && lat.abs<80) ? ((-0.988  * lat.abs) + lng ) : ((-2.5826 *lat.abs) + 193.33)
    temp=(ftemp-32)* 0.5556
      if (temp>50 || temp<-10)
      temp =rand(-10..50)
      end
      if !temp.negative? and temp < 10
        wcond = "rain"
      elsif  temp.negative?
        wcond = "snow"
      else
        wcond = "sunny"
      end
    return temp,wcond
  end

  def calc_time(lat, lng)
    time = lng/15
    Time.now.utc + time*60*60
  end
end

weather_report= WeatherSimulator.new # creating instances for WeatherSimulator
weather_report.start_simulation
