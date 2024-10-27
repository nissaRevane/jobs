# frozen_string_literal: true

require 'json'
require 'test/unit'
require_relative '../rentals_controller'

class RentalsControllerTest < Test::Unit::TestCase
  def test_index_happy_path
    assert_equal(
      happy_path_output,
      RentalsController.new(happy_path_params).index
    )
  end

  def test_index_missing_car
    assert_equal(
      missing_car_output,
      RentalsController.new(missing_car_params).index
    )
  end

  private

  def happy_path_params = File.read("#{File.dirname(__dir__)}/data/input.json")

  def happy_path_output = File.read("#{File.dirname(__dir__)}/data/expected_output.json")

  def missing_car_params
    {
      cars: [],
      rentals: [
        { id: 1, car_id: 1, start_date: '2015-12-8', end_date: '2015-12-8', distance: 100 }
      ]
    }.to_json
  end

  def missing_car_output = JSON.pretty_generate({ error: 'Car with id 1 not found' }) + "\n"
end
