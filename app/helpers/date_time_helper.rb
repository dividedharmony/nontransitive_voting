# frozen_string_literal: true

require 'date'

module DateTimeHelper
  def parse_date_time_select(params, base_name: nil)
    raise(ArgumentError, 'base_name cannot be nil') unless base_name
    datetime_array = (1..5).collect { |n| params["#{base_name}(#{n}i)"].to_i }
    DateTime.new(*datetime_array)
  end
end
