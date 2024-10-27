# frozen_string_literal: true

require 'json'
require_relative 'rental'
require_relative 'transaction_service'

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
    transaction_service = TransactionService.new(price, rental.duration_in_days)

    {
      id: rental.id,
      actions: [
        {
          who: "driver",
          type: "debit",
          amount: price
        },
        {
          who: "owner",
          type: "credit",
          amount: transaction_service.owner_credit
        },
        {
          who: "insurance",
          type: "credit",
          amount: transaction_service.insurance_credit
        },
        {
          who: "assistance",
          type: "credit",
          amount: transaction_service.assistance_credit
        },
        {
          who: "drivy",
          type: "credit",
          amount: transaction_service.drivy_credit
        }
      ]
    }
  end
end
