class GeocodeService 
  def self.call(address)
    response = Geocoder.search(address)

    # Check for response validity
    raise IOError, "Geocoder error: No response received" unless response
    raise IOError, "Geocoder error: Empty response" if response.empty?

    data = response.first.data

    # Ensure data is present and contains necessary fields
    validate_geocoder_data(data)

    # Create and return an OpenStruct with geocode data
    build_geocode_object(data)
  end

  private

  def self.validate_geocoder_data(data)
    raise IOError, "Geocoder data error: No data found" unless data
    raise IOError, "Geocoder latitude is missing" unless data.dig("geometry", "location", "lat")
    raise IOError, "Geocoder longitude is missing" unless data.dig("geometry", "location", "lng")
    raise IOError, "Geocoder place code is missing" unless data["place_id"]
  end

  def self.build_geocode_object(data)
    OpenStruct.new(
      latitude: data.dig("geometry", "location", "lat"),
      longitude: data.dig("geometry", "location", "lng"),
      place_code: data["place_id"]
    )
  end
end