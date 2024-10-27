# frozen_string_literal: 

class CommissionService
  def initialize(rental_price, rental_duration)
    @rental_price = rental_price
    @rental_duration = rental_duration
  end

  COMMISSION_RATE = 0.3
  INSURANCE_RATE = 0.5
  ASSISTANCE_DAILY_FEE = 1_00

  attr_reader :rental_price, :rental_duration, :comisssion

  def insurance_fee = (comisssion * INSURANCE_RATE).to_i

  def assistance_fee = ASSISTANCE_DAILY_FEE * rental_duration

  def drivy_fee
    [(comisssion - insurance_fee - assistance_fee).to_i, 0].max
  end

  private

  def comisssion
    @total_comisssion ||= rental_price * COMMISSION_RATE
  end
end
