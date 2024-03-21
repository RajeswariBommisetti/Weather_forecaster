class ForecastsController < ApplicationController
  def show
    @address = params[:address] || "Hyderabad, Telangana, 500049"
    begin
      @geocode = GeocodeService.call(@address)
      @weather_cache_key = "#{@geocode.place_code}"
      @weather_cache_exist = Rails.cache.exist?(@weather_cache_key)
      @weather = Rails.cache.fetch(@weather_cache_key, expires_in: 30.minutes) do
        WeatherForecastService.call(@geocode.latitude, @geocode.longitude)          
      end
    rescue => e
      flash.alert = e.message
    end
  end

end
