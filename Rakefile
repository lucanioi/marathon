require_relative 'marathon'
require_relative 'utilities/clean_slate'

task :marathon do
  Marathon.new.start
end

task :clean do
  Marathon.clean_slate
end

task m: :marathon

