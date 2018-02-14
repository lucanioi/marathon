class Runner
  class WhatTheFuck < StandardError; end

  def self.shared_context=(file)
    @@shared_context = file.strip
  end

  FILES = [
    'analytics/generator'
  ].freeze

  GEMS = [
    'pry-byebug'
  ]

  def initialize(name:, code:, laps:, setup:)
    @name    = name
    @code    = code  || ''
    @setup   = setup || ''
    @laps    = laps
    @context = Object.new

    configure!
  end

  attr_reader :name

  def configure!
    set_context

    code.prepend "#{laps}.times do\n"
    code << "\nend"
  end

  def run
    context.instance_eval(code)
  end

  private

  attr_reader :code, :laps, :setup, :context

  def shared_context
    @@shared_context
  end

  def set_context
    setup_dependencies
    context.instance_eval(shared_context) unless shared_context.empty?
    context.instance_eval(setup)
  end

  def setup_dependencies
    FILES.each do |file|
      path = File.expand_path(Runner.root_path + "/#{file}")

      context.send(:require, path)
    end

    GEMS.each do |gem|
      context.send(:require, gem)
    end
  end

  def self.root_path
    File.expand_path(Pathname.new(__FILE__) + '../../')
  end
end