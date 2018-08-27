require 'active_record/connection_adapter'
require 'byebug'

module ActiveRecord
  class Base
    def self.abstract_class=(value)
      # not implemented
    end

    def self.table_name
      name.downcase + "s"
    end

    def self.find(id)
      attributes = connection.execute(
        "SELECT * FROM #{table_name} where id = #{id.to_s}"
      ).first
      new(attributes)
    end

    def self.find_by_sql(sql)
      connection.execute(sql).map { |record| new(record) }
    end

    def self.all
      Relation.new(self)
    end

    def self.where(*args)
      all.where(*args)
    end

    def self.establish_connection(options)
      # normally 'options' would come from your database.yml file
      @@connection = ConnectionAdapter::SqliteAdapter.new(options[:database])
    end

    def self.connection
      @@connection
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
  end
end
