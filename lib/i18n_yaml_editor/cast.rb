# frozen_string_literal: true
module I18nYamlEditor
  # Transformation provides
  module Cast
    # Converts a given value to a specific data type
    def cast(klass, value)
      if klass < Numeric
        num = BigDecimal.new(value)
        num.frac == 0 ? num.to_i : num.to_f
      elsif [TrueClass, FalseClass].include?(klass)
        value.casecmp('true').zero?
      elsif klass == Array
        value.split("\r\n")
      else # String, blank
        value.to_s
      end
    end
  end
end
