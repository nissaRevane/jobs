# frozen_string_literal: true

require 'test/unit'
require_relative '../services/option_service'

class OptionServiceTest < Test::Unit::TestCase
  def test_call
    option_service = OptionService.new(1, ['gps', 'baby_seat', 'additional_insurance'])
    assert_equal 1700, option_service.call('driver')
    assert_equal 700, option_service.call('owner')
    assert_equal 1000, option_service.call('drivy')
  end
end
