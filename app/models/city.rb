class City < ApplicationRecord
  has_many :weathers

  def update_weather
    service = OpenWeatherService.new(self.name)
    data = service.fetch_weather

    if data
      self.weathers.create(
        temperature: data['main']['temp'],
        weather_description: data['weather'][0]['description']
      )
    end
  end
end
