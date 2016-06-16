#!/usr/bin/env ruby
gem 'minitest', '>= 5.0.0'
gem 'byebug'
require 'byebug'
require 'minitest/autorun'
require 'pp'
require './romans.rb'

require 'benchmark/ips'
# only run gc outside of benchmaked code:
class GCSuite
  def warming(*)
    run_gc
  end

  def running(*)
    run_gc
  end

  def warmup_stats(*)
  end

  def add_report(*)
  end

  private

    def run_gc
      GC.enable
      GC.start
      GC.disable
    end
end

SUITE = GCSuite.new

class RomansTest < Minitest::Test
  def test_works
    romans = Romans.new

    assert_equal 9,  romans.to_roman('IX')
    assert_equal 39, romans.to_roman('XXXIX')
    assert_equal 4,  romans.to_roman('IV')
    assert_equal 3,  romans.to_roman('III')

    assert_equal 'IX',    romans.to_arabic(9)
    assert_equal 'XXXIX', romans.to_arabic(39)
    assert_equal 'IV',    romans.to_arabic(4)
    assert_equal 'III',   romans.to_arabic(3)

    assert_equal 9,       romans.convert('IX')
    assert_equal 39,      romans.convert('XXXIX')
    assert_equal 4,       romans.convert('IV')
    assert_equal 3,       romans.convert('III')
    assert_equal 'IX',    romans.convert('9')
    assert_equal 'XXXIX', romans.convert('39')
    assert_equal 'IV',    romans.convert('4')
    assert_equal 'III',   romans.convert('3')
  end

  def test_implementation_performance
    Benchmark.ips do |x|
      x.config suite: SUITE
      x.report("original_keys") { Romans.new.roman_table_original }
      x.report("inverted_keys") { Romans.new.roman_table_inverted }
      x.report("keys_outside_loop") { Romans.new.roman_table_keys_outside }
      x.report("stopping_loop") { Romans.new.roman_table_stopping_loop }
      x.report("with_memory") { Romans.new.roman_table_with_partial_memory }

      x.report("original_keys") { Romans.new.roman_table_original }
      x.report("inverted_keys") { Romans.new.roman_table_inverted }
      x.report("keys_outside_loop") { Romans.new.roman_table_keys_outside }
      x.report("stopping_loop") { Romans.new.roman_table_stopping_loop }
      x.report("with_memory") { Romans.new.roman_table_with_partial_memory }
    end
    assert true
  end
end
