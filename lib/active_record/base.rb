require 'active_record/connection_adapter'

module ActiveRecord
  class Base
    def self.abstract_class=(value)
      # not implemented
    end

    def initialize(attributes = {})
      @attributes = attributes
    end

    def method_missing(name, *args)
      columns = self.class.connection.columns(self.class.table_name)
      if columns.include?(name)
        @attributes[name]
      else
        super
      end
    end

    def self.table_name
      name.downcase + "s"
    end

    def self.find(id)
      attributes = connection.execute(
        "SELECT * FROM #{self.table_name} where id = #{id.to_s}"
      ).first
      new(attributes)
    end

    def self.all
      attributes_collection = connection.execute(
        "SELECT * FROM #{self.table_name}"
      )
      attributes_collection.map { |attributes| new(attributes) }
    end

    def self.establish_connection(options)
      # normally 'options' would come from your database.yml file
      @@connection = ConnectionAdapter::SqliteAdapter.new(options[:database])
    end

    def self.connection
      @@connection
    end
  end
end
