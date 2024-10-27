# frozen_string_literal: 

class TransactionService
  def initialize(rental_price, rental_duration)
    @rental_price = rental_price
    @rental_duration = rental_duration
  end

  COMMISSION_RATE = 0.3
  INSURANCE_RATE = 0.5
  ASSISTANCE_DAILY_FEE = 1_00

  attr_reader :rental_price, :rental_duration, :comisssion

  def owner_credit = rental_price - insurance_credit - assistance_credit - drivy_credit

  def insurance_credit
    @insurance_credit ||= (comisssion * INSURANCE_RATE).to_i
  end

  def assistance_credit
    @assistance_credit ||= ASSISTANCE_DAILY_FEE * rental_duration
  end

  def drivy_credit
    @drivy_credit ||= [(comisssion - insurance_credit - assistance_credit).to_i, 0].max
  end

  private

  def comisssion
    @total_comisssion ||= rental_price * COMMISSION_RATE
  end
end
