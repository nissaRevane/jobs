# frozen_string_literal: true

require_relative 'rentals_controller'

params = File.read("#{__dir__}/data/input.json")

File.write(
  "#{__dir__}/data/output.json",
  RentalsController.new(params).index
)
