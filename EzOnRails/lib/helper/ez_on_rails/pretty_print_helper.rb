# frozen_string_literal: true

# Module for pretty printing ruby data in template files.
module EzOnRails::PrettyPrintHelper
  # returns a pretty print of the given data.
  # Data is expected to be a rubs hash or array.
  # t(...) and I18n.t(...) calls within quotes will be extracted to the medthods itselfs,
  # hence the content can be printed to some source directly.
  # If some String contains the parts model_name.human, the quotes will also be removed.
  # num_indents is the number of spaces every line of the result will be prefixed with.
  # If the parameter ignore_first_indent is set to true, the first line will not be prefixed with spaces,
  # hence the result can be used to be behind some attribute assignment.
  # If the parametrer symbolize_all is set to true, all entries surrounded by '' or "" will be changed to a symbol.
  def pretty_print(data, num_indents = 4, ignore_first_indent: false, symbolize_all: false)
    # first convert to json because json is pretty printed
    pretty = JSON.pretty_generate data

    # replace json keys with ruby symbols
    pretty.gsub!(/"(.+)":/, '\1:')
    pretty.gsub!(/"([^-\n]+)"/, ':\1') if symbolize_all

    # replace "I18n.t..." Methodes with I18n.t(
    pretty.gsub!(/"I18n.t\((.+)\)"/, 'I18n.t(\1)')

    # replace "t..." Methodes with t(
    pretty.gsub!(/"t\((.+)\)"/, 't(\1)')

    # remove quotes from ".model_name.human" Methods
    pretty.gsub!(/"(.+\.model_name\.human.*)"/, '\1')

    # replace double quotes with single quotes
    pretty.tr!('"', '\'')

    # add indents because the menu structure is placed in a class method
    pretty.indent!(num_indents)

    # remove indents of first line if ignore_first_indent is set to true
    if ignore_first_indent
      lines = pretty.split("\n")
      lines[0] = lines[0][num_indents..]
      pretty = lines.join("\n")
    end

    pretty
  end

  # returns the content of the method having the given method_symbol as symbol.
  # The signature of the method itself will be removed.
  # The translation helper methods t(...) will be encapsulated in strings.
  # Also calls of I18n.t(...) will be encapsulated.
  # Also lines having the part model_name.human will be encapsulated, because rails uses
  # this for translation for active record objects.
  # Hence this can be used to work in generators without accidently translate contents
  # of hashes or something else.
  def method_content(module_const, method_symbol)
    source = module_const.method(method_symbol).source.split("\n")[1..-2].join("\n")
    source.gsub!(/I18n.t\((.+)\)/, '"I18n.t(\1)"')
    source.gsub!(/(?!\.)t\((.+)\)/, '"t(\1)"')
    source.gsub!(/([A-Za-z0-9]+)\.model_name\.human([^(])/, '"\1.model_name.human\2"')
    source.gsub!(/([A-Za-z0-9]+)\.model_name\.human\((.+)\)/, '"\1.model_name.human(\2)"')

    source
  end
end
