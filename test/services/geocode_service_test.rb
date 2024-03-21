require 'test_helper'

class GeocodeServiceTest < ActiveSupport::TestCase
  test "call with known address" do
    address = "United States"
    geocode = GeocodeService.call(address)
    assert_in_delta 37.09024, geocode.latitude, 0.1
    assert_in_delta -95.712891, geocode.longitude, 0.1
  end
end