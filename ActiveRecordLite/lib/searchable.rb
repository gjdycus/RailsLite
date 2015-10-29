require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    results = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{params.map { |key, value| "#{key} = ?" }.join(" AND ")}
    SQL

    return results if results.empty?
    results.map { |params| self.new(params) }
  end
end
