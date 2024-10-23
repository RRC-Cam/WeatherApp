class City < ApplicationRecord
  has_many :weathers, dependent: :destroy

    # Validation to ensure that the name is always present
    validates :name, presence: true

    # Validation to ensure that the city name is unique
    validates :name, uniqueness: true

    def update_weather
      # Fetch weather data from OpenWeather API
      api_key = "3448845624d0c58ac787549dffb44cb2"
      uri = URI("https://api.openweathermap.org/data/2.5/weather?q=#{self.name}&appid=#{api_key}&units=metric")
      response = Net::HTTP.get(uri)
      weather_data = JSON.parse(response)

      # Update weather data if the response is valid
      if weather_data['main'] && weather_data['weather']
        self.weathers.create!(
          temperature: weather_data['main']['temp'],
          weather_description: weather_data['weather'].first['description']
        )
      else
        puts "Weather data not found for #{self.name}"
      end

      def disallow_usa_name
        if name.downcase == "united states of america"
          errors.add(:name, 'cannot be "United States of America"')
        end
      end
  end
end
