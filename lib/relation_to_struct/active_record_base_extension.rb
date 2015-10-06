module RelationToStruct::ActiveRecordBaseExtension
  extend ::ActiveSupport::Concern

  module ClassMethods
    def structs_from_sql(struct_class, sql, binds=[])
      result = connection.select_all(sanitize_sql(sql, nil), "Structs SQL Load", binds)

      if result.columns.size != struct_class.members.size
        raise ArgumentError, 'Expected struct fields and columns lengths to be equal'
      end

      if result.columns.size == 1
        result.cast_values().map do |tuple|
          struct_class.new(tuple)
        end
      else
        result.cast_values().map do |tuple|
          struct_class.new(*tuple)
        end
      end
    end

    def pluck_from_sql(sql, binds=[])
      result = connection.select_all(sanitize_sql(sql, nil), "Structs SQL Load", binds)
      result.cast_values()
    end
  end
end

::ActiveRecord::Base.send(:include, RelationToStruct::ActiveRecordBaseExtension)
