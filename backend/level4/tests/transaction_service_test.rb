# frozen_string_literal: true

require 'test/unit'
require_relative '../transaction_service'

class TransactionServiceTest < Test::Unit::TestCase
  def test_insurance_credit
    commission_service = TransactionService.new(10_00, 1)
    assert_equal 1_50, commission_service.insurance_credit
  end

  def test_assistance_credit
    commission_service = TransactionService.new(10_00, 7)
    assert_equal 7_00, commission_service.assistance_credit
  end

  def test_drivy_credit
    commission_service = TransactionService.new(10_00, 1)
    assert_equal 50, commission_service.drivy_credit
  end

  def test_drivy_credit_when_other_credits_are_higher_than_commission
    commission_service = TransactionService.new(100, 1)
    assert_equal 0, commission_service.drivy_credit
  end
end
