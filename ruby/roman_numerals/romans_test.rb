#!/usr/bin/env ruby
gem 'minitest', '>= 5.0.0'
gem 'byebug'
require 'byebug'
require 'minitest/autorun'
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
    assert_equal 9, romans.to_roman('IX')
    assert_equal 39, romans.to_roman('XXXIX')
    assert_equal 4, romans.to_roman('IV')
    assert_equal 3, romans.to_roman('III')
  end

  def test_implementation_performance
    Benchmark.ips do |x|
      x.config suite: SUITE
      x.report("original_keys") { Romans.new.roman_table_original }
      x.report("inverted_keys") { Romans.new.roman_table_inverted }
      x.report("original_keys") { Romans.new.roman_table_original }
      x.report("inverted_keys") { Romans.new.roman_table_inverted }
    end
    assert true
  end
end
