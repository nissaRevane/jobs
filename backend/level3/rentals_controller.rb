# frozen_string_literal: true

require 'json'
require_relative 'rental'
require_relative 'commission_service'

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
        rentals: rentals.map { |rental| financial_amounts(Rental.new(**rental)) }
      })+ "\n"
    rescue MissingCarError => e
      JSON.pretty_generate({ error: e.message })+ "\n"
    end
  end

  private

  def financial_amounts(rental)
    car = rental.find_car!(cars)
    price = rental.price(car[:price_per_km], car[:price_per_day])
    commision_service = CommissionService.new(price, rental.duration_in_days)

    {
      id: rental.id,
      price:,
      commission: {
        insurance_fee: commision_service.insurance_fee,
        assistance_fee: commision_service.assistance_fee,
        drivy_fee: commision_service.drivy_fee
      }
    }
  end
end
