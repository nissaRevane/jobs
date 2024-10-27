# frozen_string_literal: true

class OptionService
  def initialize(rental_duration, rental_options)
    @rental_duration = rental_duration
    @rental_options = rental_options
  end

  attr_reader :rental_duration, :rental_options

  PAID_OPTIONS = {
    'gps' => { beneficiary: 'owner', price: 500 },
    'baby_seat' => { beneficiary: 'owner', price: 200 },
    'additional_insurance' => { beneficiary: 'drivy', price: 1000 }
  }.freeze

  def call(beneficiary)
    selected_options(beneficiary).sum do |option|
      PAID_OPTIONS[option][:price] * rental_duration
    end
  end

  private

  def selected_options(beneficiary)
    return all_paid_options if beneficiary == 'driver'

    all_paid_options.select do |option|
      PAID_OPTIONS[option][:beneficiary] == beneficiary
    end
  end

  def all_paid_options
    rental_options.select do |option|
      PAID_OPTIONS.keys.include?(option)
    end
  end
end