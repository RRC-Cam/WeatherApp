class City < ApplicationRecord
  has_many :weathers, dependent: :destroy

  def update_weather
    service = OpenWeatherService.new(self.name)
    data = service.fetch_weather

    if data
      # Delete previous weather data for this city
      self.weathers.destroy_all

      # Create a new weather record
      self.weathers.create(
        temperature: data['main']['temp'],
        weather_description: data['weather'][0]['description']
      )
    end
  end
end
