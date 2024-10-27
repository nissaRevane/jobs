# frozen_string_literal: true

require 'json'
require_relative 'rental'
require_relative 'services/transaction_service'

class RentalsController
  def initialize(params)
    params = JSON.parse(params, symbolize_names: true)

    @cars = params[:cars]
    @rentals = params[:rentals]
    @options = params[:options]
  end

  attr_reader :cars, :rentals, :options

  def index
    begin
      JSON.pretty_generate({
        rentals: rentals.map { |rental| transaction_details(Rental.new(**rental)) }
      }).gsub(/\[\n\s*\n\s*\]/, '[]')+ "\n"
    rescue MissingCarError => e
      JSON.pretty_generate({ error: e.message })+ "\n"
    end
  end

  private

  def transaction_details(rental)
    car = rental.find_car!(cars)
    rental_options = rental.find_options(options)
    transaction_service = transaction_service(rental, rental_options)

    {
      id: rental.id,
      options: rental_options,
      actions: [
        {
          who: "driver",
          type: "debit",
          amount: transaction_service.driver_debit
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

  def transaction_service(rental, rental_options)
    car = rental.find_car!(cars)

    TransactionService.new(
      rental_base_price: rental.base_price(car[:price_per_km], car[:price_per_day]),
      rental_duration: rental.duration_in_days,
      rental_options:
    )
  end
end
