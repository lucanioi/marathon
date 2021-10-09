require_relative '../lib/marathon'

class Marathon
  def self.clean_slate
    clean_slate = "\n\n\n" + DIVIDER + "\n\n\n"

    Dir[FILES_PATH].each do |path|
      File.write(path, clean_slate)
    end

    File.truncate(SHARED_CONTEXT_PATH, 0)

    puts 'done!'
  end
end
