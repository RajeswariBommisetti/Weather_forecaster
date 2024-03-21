class WeatherForecastService
  def self.call(latitude, longitude)
    conn = create_connection

    response = conn.get('/data/2.5/weather', {
      appid: Rails.application.credentials.openweather_api_key,
      lat: latitude,
      lon: longitude,
      units: "metric"
    })

    body = parse_response(response)

    create_weather_object(body)
  end

  private

  def self.create_connection
    Faraday.new("https://api.openweathermap.org") do |f|
      f.request :json
      f.request :retry # retry transient failures
      f.response :json
    end
  end

  def self.parse_response(response)
    body = response.body
    raise IOError.new("OpenWeather response body failed") unless body
    body
  end

  def self.create_weather_object(body)
    main = body.fetch("main") { raise IOError.new("OpenWeather main section is missing") }
    weather_data = body.fetch("weather") { raise IOError.new("OpenWeather weather section is missing") }.first
    description = weather_data.fetch("description") { raise IOError.new("OpenWeather weather description is missing") }
    binding.pry

    OpenStruct.new(
      temperature: main["temp"],
      temperature_min: main["temp_min"],
      temperature_max: main["temp_max"],
      description: description 
    )
  end
end