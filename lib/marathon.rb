require 'pry-byebug'
require 'benchmark'
require_relative 'runner'

class Marathon
  class MarathonCancelled < Exception; end

  DEFAULT_LAPS = 100
  FILES_PATH = '../runners/*.rb'.freeze
  SHARED_CONTEXT_PATH = 'utilities/shared_context.rb'.freeze
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
    @laps = get_laps || DEFAULT_LAPS
    puts "Running #{laps} laps..."
  end

  def set
    set_shared_context
    set_runners
  end

  def go
    benchmark do |bm|
      runners.each do |runner|
        bm.report(runner.name) { runner.run }
      end
    end
  end

  def set_shared_context
    Runner.shared_context = File.read(SHARED_CONTEXT_PATH)
  end

  def set_runners
    runner_files do |file, name|
      setup, code = split_setup_and_code File.read(file)
      runners << Runner.new(name: name, code: code, setup: setup, laps: laps)
    end
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

  def runner_files(&blk)
    Dir[FILES_PATH].each do |path|
      name = File.basename(path, '.rb')
      next unless FILES.include? name
      blk.call(path, name)
    end
  end

  def divider
    DIVIDER
  end

  def shell_arg
    ARGV[1]
  end
end


