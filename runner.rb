class Runner
  class WhatTheFuck < StandardError; end

  def initialize(name:, code:, laps:)
    @name = name
    @code = code
    @laps = laps
    configure!
  end

  private; attr_reader :code, :laps
  public; attr_reader :name

  def configure!
    code.prepend "#{laps}.times do\n"
    code << "\nend"
  end

  def run
    eval(code)
  end
end