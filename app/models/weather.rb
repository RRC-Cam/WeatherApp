class Weather < ApplicationRecord
  belongs_to :city

  # Validation to ensure that temperature is present
  validates :temperature, presence: true

  # Validation to ensure that temperature is within a realistic range (-100°C to 100°C)
  validates :temperature, numericality: { greater_than_or_equal_to: -100, less_than_or_equal_to: 100 }

end
