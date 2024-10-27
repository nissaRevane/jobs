# frozen_string_literal: 

require_relative 'option_service'

class TransactionService
  def initialize(rental_base_price:, rental_duration:, rental_options: [])
    @rental_base_price = rental_base_price
    @rental_duration = rental_duration
    @rental_options = rental_options
  end

  COMMISSION_RATE = 0.3
  INSURANCE_RATE = 0.5
  ASSISTANCE_DAILY_FEE = 1_00

  attr_reader :rental_base_price, :rental_duration, :rental_options, :comisssion

  def driver_debit
    (rental_base_price + option_price_service.call('driver')).to_i
  end

  def owner_credit
    (rental_base_price + option_price_service.call('owner') - comisssion).to_i
  end

  def insurance_credit
    (insurance_fee + option_price_service.call('insurance')).to_i
  end

  def assistance_credit = (ASSISTANCE_DAILY_FEE * rental_duration).to_i

  def drivy_credit
    (drivy_fee + option_price_service.call('drivy')).to_i
  end

  private

  def comisssion
    @comisssion ||= rental_base_price * COMMISSION_RATE
  end

  def insurance_fee = comisssion * INSURANCE_RATE

  def drivy_fee = [(comisssion - insurance_credit - assistance_credit).to_i, 0].max

  def option_price_service
    @option_price_service ||= OptionService.new(rental_duration, rental_options)
  end
end
