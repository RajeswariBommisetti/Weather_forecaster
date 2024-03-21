require 'test_helper'

class WeatherForecastServiceTest < ActiveSupport::TestCase

  test "verify forecast data" do
    # Example address is 1 Infinite Loop, Cupertino, California
    latitude = 37.331669
    longitude = -122.030098 
    weather = WeatherForecastService.call(latitude, longitude)
    assert_includes -4..44, weather.temperature
    assert_includes -4..44, weather.temperature_min
    assert_includes -4..44, weather.temperature_max
    refute_empty weather.description
  end

end