require 'pry-byebug'
require 'benchmark'
require_relative 'runner'

class Marathon
  class MarathonCancelled < Exception; end

  FILES_PATH = 'marathon/runners/*.rb'
  FILES = %w(blue red green)

  def initialize
    @runners = []
  end

  def start
    ready
    set
    go
  end

  private

  attr_reader :laps, :runners, :results

  def ready
    @laps = get_laps || 1
  end

  def set
    Dir[FILES_PATH].each do |path|
      name = File.basename(path, '.rb')
      next unless FILES.include? name
      code = File.read(path)

      runners << Runner.new(name: name, code: code, laps: laps)
    end
  end

  def go
    race do |x|
      runners.each do |runner|
        x.report(runner.name) { runner.run }
      end
    end
  end

  def race(&blk)
    Benchmark.bm(6) do |x|
      blk.call(x)
    end
  end

  def get_laps
   if shell_arg
      raise MarathonCancelled, 'Bad shell arguments' unless shell_arg =~ /^\d+/
      shell_arg.to_i
    end
  end

  def shell_arg
    ARGV[1]
  end
end


