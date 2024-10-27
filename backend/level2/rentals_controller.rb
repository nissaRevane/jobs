# frozen_string_literal: true

require 'json'
require_relative 'rental'

class RentalsController
  def initialize(params)
    params = JSON.parse(params, symbolize_names: true)

    @cars = params[:cars]
    @rentals = params[:rentals]
  end

  attr_reader :cars, :rentals

  def index
    begin
      JSON.pretty_generate({
        rentals: rentals.map { |rental| rental_price(Rental.new(**rental)) }
      })+ "\n"
    rescue MissingCarError => e
      JSON.pretty_generate({ error: e.message })+ "\n"
    end
  end

  private

  def rental_price(rental)
    car = rental.find_car!(cars)
    {
      id: rental.id,
      price: rental.price(car[:price_per_km], car[:price_per_day])
    }
  end
end
