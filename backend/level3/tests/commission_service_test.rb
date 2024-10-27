# frozen_string_literal: true

require 'test/unit'
require_relative '../commission_service'

class CommissionServiceTest < Test::Unit::TestCase
  def test_insurance_fee
    commission_service = CommissionService.new(10_00, 1)
    assert_equal 1_50, commission_service.insurance_fee
  end

  def test_assistance_fee
    commission_service = CommissionService.new(10_00, 7)
    assert_equal 7_00, commission_service.assistance_fee
  end

  def test_drivy_fee
    commission_service = CommissionService.new(10_00, 1)
    assert_equal 50, commission_service.drivy_fee
  end

  def test_drivy_fee_when_other_fees_are_higher_than_commission
    commission_service = CommissionService.new(100, 1)
    assert_equal 0, commission_service.drivy_fee
  end
end
