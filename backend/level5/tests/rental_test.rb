# frozen_string_literal: true

require 'test/unit'
require_relative '../rental'

class RentalTest < Test::Unit::TestCase
  def test_base_price_for_one_day
    rental = Rental.new(id: 1, car_id: 1, start_date: '2015-12-8', end_date: '2015-12-8', distance: 100)
    assert_equal 30_00, rental.base_price(10, 20_00)
  end

  def test_base_price_for_four_days
    rental = Rental.new(id: 1, car_id: 1, start_date: '2015-12-8', end_date: '2015-12-11', distance: 100)
    assert_equal 84_00, rental.base_price(10, 20_00)
  end

  def test_base_price_for_ten_days
    rental = Rental.new(id: 1, car_id: 1, start_date: '2015-12-8', end_date: '2015-12-17', distance: 100)
    assert_equal 168_00, rental.base_price(10, 20_00)
  end

  def test_base_price_for_eleven_days
    rental = Rental.new(id: 1, car_id: 1, start_date: '2015-12-8', end_date: '2015-12-18', distance: 100)
    assert_equal 178_00, rental.base_price(10, 20_00)
  end

  def test_find_car
    cars = [{ id: 1, price_per_day: 20_00, price_per_km: 10 }]
    rental = Rental.new(id: 1, car_id: 1, start_date: '2015-12-8', end_date: '2015-12-8', distance: 100)
    assert_equal cars.first, rental.find_car!(cars)
  end

  def test_find_car_missing
    cars = []
    rental = Rental.new(id: 1, car_id: 1, start_date: '2015-12-8', end_date: '2015-12-8', distance: 100)
    assert_raise(MissingCarError) { rental.find_car!(cars) }
  end

  def test_duration_in_days
    rental = Rental.new(id: 1, car_id: 1, start_date: '2015-12-8', end_date: '2016-12-7', distance: 100)
    assert_equal 366, rental.duration_in_days
  end
end