# frozen_string_literal: true

require 'date'

class MissingCarError < StandardError; end

class Rental
  def initialize(id:, car_id:, start_date:, end_date:, distance:)
    @id = id
    @car_id = car_id
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @distance = distance
  end

  attr_reader :car_id, :start_date, :end_date
  attr_accessor :id, :distance

  DURATION_DISCOUNTS = { 10 => 50, 4 => 30, 1 => 10, 0 => 0 }.freeze

  def price(price_per_km, price_per_day)
    (time_component(price_per_day) + distance_component(price_per_km)).to_i
  end

  def find_car!(cars)
    cars.find { |car| car[:id] == car_id } ||
      raise(MissingCarError, "Car with id #{car_id} not found")
  end

  private

  def time_component(price_per_day)
    remaining_days_to_pay = (end_date - start_date).to_i + 1

    DURATION_DISCOUNTS.inject(0) do |sum, (day_threshold, discount)|
      price_per_extra_day = price_per_day * (1 - discount / 100.0)
      extra_time = [remaining_days_to_pay - day_threshold, 0].max

      remaining_days_to_pay = [remaining_days_to_pay, day_threshold].min
      sum += extra_time * price_per_extra_day
    end
  end

  def distance_component(price_per_km) = distance * price_per_km
end
