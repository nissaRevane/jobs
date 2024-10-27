# frozen_string_literal: true

require 'test/unit'
require_relative '../rentals_controller'

class RentalsControllerTest < Test::Unit::TestCase
  def setup
    input_path = "#{File.dirname(__dir__)}/data/input.json"
    params = File.read(input_path)

    @rentals_controller = RentalsController.new(params)
  end

  def test_index
    expected_output_path = "#{File.dirname(__dir__)}/data/expected_output.json"
    expected_output = File.read(expected_output_path)

    assert_equal(expected_output, @rentals_controller.index)
  end
end
