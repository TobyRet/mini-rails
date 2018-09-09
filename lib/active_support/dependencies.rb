# frozen_string_literal: true

require 'byebug'

module ActiveSupport
  module Dependencies
    extend self

    attr_accessor :autoload_paths

    self.autoload_paths = []

    def search_for_file(name)
      autoload_paths.each do |path|
        file = File.join(path, "#{name}.rb")
        return file if File.file? file
      end
      nil
    end
  end
end

class Module
  # remove_method :const_missing

  def const_missing(name)
    if file = ActiveSupport::Dependencies.search_for_file(name.to_s.underscore)
      require file.sub(/\.rb$/, '')
      const_get(name)
    else
      raise NameError, "Bad constant #{name}"
    end
  end
end
