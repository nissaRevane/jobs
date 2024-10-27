# frozen_string_literal: true

require 'date'
require 'json'

class RentalsController
  def initialize(params)
    params = JSON.parse(params, symbolize_names: true)

    @cars = params[:cars]
    @rentals = params[:rentals]
  end

  attr_reader :cars, :rentals

  def index
    JSON.pretty_generate(
      { rentals: rentals.map { |rental| rental_price(rental) } }
    ) + "\n"
  end

  private

  def rental_price(rental)
    car = cars.find { |car| car[:id] == rental[:car_id] }

    {
      id: rental[:id],
      price: time_component(car, rental) + distance_component(car, rental)
    }
  end

  def time_component(car, rental) = duration_in_days(rental) * car[:price_per_day]

  def distance_component(car, rental) = rental[:distance] * car[:price_per_km]

  def duration_in_days(rental)
    (Date.parse(rental[:end_date]) - Date.parse(rental[:start_date])).to_i + 1
  end
end