require 'pry-byebug'
require 'benchmark'

class Marathon
  class MarathonCancelled < Exception; end

  FILES_PATH = 'marathon/runners/*.rb'
  FILES = %w(blue red green)

  Runner = Struct.new(:name, :code)

  def initialize
    @runners = []
    @results = {}
  end

  def run
    ready
    set
    go
    scores
  end

  private

  attr_reader :laps, :runners, :results, :shell_arg

  def ready
    @laps = get_laps || 1
  end

  def set
    Dir[FILES_PATH].each do |path|
      name = File.basename(path, '.rb')
      next unless FILES.include? name
      code = File.read(path)

      runners << Runner.new(name, code)
    end
  end

  def go
    runners.each do |runner|
      results[runner.name] = time(runner.code)
    end
  end

  def scores
    sorted_results = results.sort_by { |_k, v| v.real }.to_h

    sorted_results.each do |k, v|
      printf "%-5s %s\n", k, v
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

  def time(code)
    Benchmark.measure do
      laps.times do
        eval(code)
      end
    end
  end
end


