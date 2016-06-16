#!/usr/bin/env ruby
gem 'minitest', '>= 5.0.0'
gem 'byebug'
require 'byebug'
require 'minitest/autorun'
require './romans.rb'

# Test data version:
# deb225e Implement canonical dataset for scrabble-score problem (#255)

class RomansTest < Minitest::Test
  def test_works
    assert_equal 9, Romans.new.to_roman('IX')
    assert_equal 39, Romans.new.to_roman('XXXIX')
    assert_equal 4, Romans.new.to_roman('IV')
    assert_equal 3, Romans.new.to_roman('III')
  end
end
