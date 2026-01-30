# frozen_string_literal: true

# Validator to validate json fields against json schemas.
# Accepts a schema option that should be the full path to a valid json schema file.
# If the path is not given, it will be guessed from the records class and attribute name.
# In this case the path is 'app/models/json_schemas/{model_name}/{attribute_name}.json'.
# The value can be given as string or json or hash value. In any case it is parsed to json
# before validation.
class JsonSchemaValidator < ActiveModel::EachValidator
  # Called for the attributes passed in the validators options.
  # Validates the json schema given by the schema path.
  # If no schema path is given, the path to the schema file
  # is suggested to be 'app/models/json_schemas/{model_name}/{attribute_name}.json'.
  # The value can be given as string or json or hash value. In any case it is parsed to json
  # before validation.
  def validate_each(record, attribute, value)
    return if value.blank?

    # get the schema
    schema_path = options[:schema] || Rails.root.join('app', 'models', 'json_schemas', record.class.to_s.underscore,
                                                      "#{attribute}.json")
    schema = File.read(schema_path)

    # if value is a string containing a ruby hash, deserialize it
    value = parse_json(record, attribute, value)

    # validate the schema
    schemer = JSONSchemer.schema(schema)
    errors = schemer.validate(value.as_json).to_a

    # model is valid
    return if errors.empty?

    # append every error
    errors.each do |error|
      record.errors.add(attribute, error['details'], value:)
    end
  end

  protected

  # Returns the json from the specified value.
  # If the value is a string, it will be converted to json.
  # If the string seems to be a serialized ruby hash, it will be converted
  # to json.
  def parse_json(record, attribute, value)
    return value if value.blank?

    return value unless value.is_a?(String)

    JSON.parse(value)
  rescue JSON::ParserError
    record.errors.add(attribute, I18n.t(:'ez_on_rails.validators.json_schema.json_parse_error'), value:)
  end
end
