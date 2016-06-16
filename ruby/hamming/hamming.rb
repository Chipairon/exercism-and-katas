module BookKeeping
  VERSION = 3
end

class Hamming
  def self.compute a, b
    compute_manual_count a, b
  end

  def self.compute_idiomatic a, b
    raise ArgumentError, "Lengths must match." if a.length != b.length
    (0..a.length).select do |index|
      a[index] != b[index]
    end.count
  end

  def self.compute_manual_count a, b
    raise ArgumentError, "Lengths must match." if a.length != b.length

    dist = 0
    (0..a.length).each do |index|
      dist += 1 if a[index] != b[index]
    end
    dist
  end

  def self.compute_char_arrays a, b
    raise ArgumentError, "Lengths must match." if a.length != b.length

    dist = 0
    b_chars = b.chars
    a_chars = a.chars
    (0..a.length).each do |index|
      dist += 1 if a_chars[index] != b_chars[index]
    end
    dist
  end

  def self.compute_char_arrays_auto_count a, b
    raise ArgumentError, "Lengths must match." if a.length != b.length

    b_chars = b.chars
    a_chars = a.chars
    (0..a.length).select do |index|
      a_chars[index] != b_chars[index]
    end.count
  end

  def self.compute_each_with_index a, b
    raise ArgumentError, "Lengths must match." if a.length != b.length
    dist = 0
    a.chars.each_with_index do |char, index|
      dist = dist + 1 if char != b[index]
    end
    dist
  end
end

strand1 = "GATATAGAGA" * 1_000_000
strand2 = "TATATAGAGA" * 1_000_000

require 'benchmark'

Benchmark.bmbm do |x|
  x.report("with_char_arrays") { Hamming.compute_char_arrays(strand1, strand2) }
  x.report("compute_char_arrays_auto_count") { Hamming.compute_char_arrays_auto_count(strand1, strand2) }
  x.report("select+count") { Hamming.compute_idiomatic(strand1, strand2) }
  x.report("manual_count") { Hamming.compute_manual_count(strand1, strand2) }
  x.report("maunal_each_with_index") { Hamming.compute_each_with_index(strand1, strand2) }
end

#require 'benchmark/ips'

## only run gc outside of benchmaked code:
#class GCSuite
  #def warming(*)
    #run_gc
  #end

  #def running(*)
    #run_gc
  #end

  #def warmup_stats(*)
  #end

  #def add_report(*)
  #end

  #private

  #def run_gc
    #GC.enable
    #GC.start
    #GC.disable
  #end
#end

#suite = GCSuite.new

#Benchmark.ips do |x|
  #x.config suite: suite
  #x.report("with_char_arrays") { Hamming.compute_char_arrays(strand1, strand2) }
  #x.report("select+count") { Hamming.compute_idiomatic(strand1, strand2) }
  #x.report("manual_count") { Hamming.compute_manual_count(strand1, strand2) }
  #x.report("compute_char_arrays_auto_count") { Hamming.compute_char_arrays_auto_count(strand1, strand2) }
#end
