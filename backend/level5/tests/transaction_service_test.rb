# frozen_string_literal: true

require 'test/unit'
require_relative '../services/transaction_service'

class TransactionServiceTest < Test::Unit::TestCase
  def test_driver_debit
    transaction_service = TransactionService.new(rental_base_price: 10_00, rental_duration: 1)
    assert_equal 10_00, transaction_service.driver_debit
  end

  def test_driver_debit_when_options
    transaction_service = TransactionService.new(
      rental_base_price: 10_00,
      rental_duration: 1,
      rental_options: ['gps']
    )

    assert_equal 15_00, transaction_service.driver_debit
  end


  def test_owner_credit
    transaction_service = TransactionService.new(rental_base_price: 10_00, rental_duration: 1)
    assert_equal 7_00, transaction_service.owner_credit
  end

  def test_owner_credit_when_options
    transaction_service = TransactionService.new(
      rental_base_price: 10_00,
      rental_duration: 1,
      rental_options: ['gps']
    )

    assert_equal 12_00, transaction_service.owner_credit
  end

  def test_insurance_credit
    transaction_service = TransactionService.new(rental_base_price: 10_00, rental_duration: 1)
    assert_equal 1_50, transaction_service.insurance_credit
  end

  def test_assistance_credit
    transaction_service =TransactionService.new(rental_base_price: 10_00, rental_duration: 7)
    assert_equal 7_00, transaction_service.assistance_credit
  end

  def test_drivy_credit
    transaction_service = TransactionService.new(rental_base_price: 10_00, rental_duration: 1)
    assert_equal 50, transaction_service.drivy_credit
  end

  def test_drivy_credit_when_other_credits_are_higher_than_commission
    transaction_service = TransactionService.new(rental_base_price: 1_00, rental_duration: 1)
    assert_equal 0, transaction_service.drivy_credit
  end
end
