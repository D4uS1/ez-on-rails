# frozen_string_literal: true

# Service to parse the search parameter having the schema defined in the
# swagger schemas and convert it to a formatthat is usable by the search enbgine.
# The entry point is the parse method.
class EzOnRails::SearchFilterParser
  # maps the operators given by the swagger schema to the operators that are usable by
  # the search engine.
  OPERATOR_MAP = {
    eq: '=',
    neq: '!=',
    isnull: 'null?',
    isnotnull: '!null?',
    lt: '<',
    lte: '<=',
    gt: '>',
    gte: '>=',
    contains: '~',
    doesnotcontain: '!~',
    isempty: 'set?',
    isnotempty: '!set?'
  }.freeze

  # Parses the specified value having the search parameter matching the swagger schema
  # and converts it to a readable format for the used search engine.
  def self.parse(value)
    return nil unless value

    search_filter_composition?(value) ? parse_search_filter_composition(value) : parse_search_filter(value)
  end

  # Parses the specified value to return a string that is compatible with the search engine.
  # The value is treated as SearchFieldComposition as it is defined in the swagger schema.
  def self.parse_search_filter_composition(value)
    operator = value[:logic]
    operands = value[:filters].map do |filter|
      search_filter?(filter) ? parse_search_filter(filter) : parse_search_filter_composition(filter)
    end

    "(#{operands.join(" #{operator} ")})"
  end

  # Parses the specified value to return a string that is compatible with the search engine.
  # The value is treated as SearchField as it is defined in the swagger schema.
  def self.parse_search_filter(value)
    left_operand = value[:field]&.underscore
    operator = OPERATOR_MAP[value[:operator].to_sym]
    right_operand = value[:value].is_a?(String) ? "\"#{value[:value]}\"" : value[:value]

    return "(#{operator} #{left_operand || right_operand})" if operator.include?('set?') || operator.include?('null?')

    "(#{left_operand} #{operator} #{right_operand})"
  end

  # Returns whether the specified value is a SearchFieldComposition as it is defined in the swagger schema.
  def self.search_filter_composition?(value)
    value.key?(:logic)
  end

  # Returns whether the specified value is a SearchField as it is defined in the swagger schema.
  def self.search_filter?(value)
    value.key?(:operator)
  end
end
