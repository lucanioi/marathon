require_relative 'lib/marathon'
require_relative 'utilities/clean_slate'

task :marathon do
  ARGV.each { |a| task a.to_sym }
  Marathon.new.start
end

task :clean do
  Marathon.clean_slate
end

task m: :marathon
