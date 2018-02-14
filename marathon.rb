require 'pry-byebug'
require 'benchmark'
require_relative 'runner'

class Marathon
  class MarathonCancelled < Exception; end

  FILES_PATH = 'marathon/runners/*.rb'.freeze
  SHARED_CONTEXT_PATH = 'marathon/utilities/shared_context.rb'.freeze
  FILES = %w(blue red green).freeze
  DIVIDER = '#====================== setup above, code below =======================#'.freeze

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
    set_shared_context
    set_runners
  end

  def go
    benchmark do |bm|
      runners.reverse_each do |runner|
        bm.report(runner.name) { runner.run }
      end
    end
  end

  def set_runners
    Dir[FILES_PATH].each do |path|
      name = File.basename(path, '.rb')
      next unless FILES.include? name
      setup, code = split_setup_and_code File.read(path)

      runners << Runner.new(name: name, code: code, setup: setup, laps: laps)
    end
  end

  def set_shared_context
    Runner.shared_context = File.read(SHARED_CONTEXT_PATH)
  end

  def benchmark(&blk)
    Benchmark.bmbm do |bm|
      blk.call(bm)
    end
  end

  def get_laps
   if shell_arg
      raise MarathonCancelled, 'Bad shell arguments' unless shell_arg =~ /^\d+/
      shell_arg.to_i
    end
  end

  def split_setup_and_code(file)
    unless file.include? divider
      raise MarathonCancelled, 'Divider missing from runners'
    end

    file.split(divider)
  end

  def divider
    DIVIDER
  end

  def shell_arg
    ARGV[1]
  end
end


