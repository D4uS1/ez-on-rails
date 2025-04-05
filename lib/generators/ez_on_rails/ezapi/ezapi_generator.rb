# frozen_string_literal: true

require 'rails/generators'
require 'helper/ez_on_rails/pretty_print_helper'
require 'helper/ez_on_rails/resource_helper'
require 'helper/ez_on_rails/route_helper'

module EzOnRails
  # Generator class to generate some ApiController.
  # The API only responses to json.
  # It can be related to a resource by using the --resource argument, but it can also just contain some
  # actions.
  class EzapiGenerator < Rails::Generators::NamedBase
    include ::EzOnRails::RouteHelper
    include ::EzOnRails::ResourceHelper
    include ::EzOnRails::PrettyPrintHelper

    source_root File.expand_path('templates', __dir__)
    argument :actions, type: :array, default: []
    class_option :resource, type: :string, default: nil
    class_option :authenticable, type: :string, default: nil

    # Extracts the given options from the command lien arguments and saves them to instance variables.
    def set_options
      @resource = options['resource']&.gsub('/', '::')
      @resource_namespace = @resource.split('::')[0...-1].join('::') unless @resource.blank?
      @resource_namespace_path = "#{@resource_namespace.underscore}/"  unless @resource_namespace.blank?
      @resource_namespace_prefix = "#{@resource_namespace.gsub('::', '_').underscore}_"   unless @resource_namespace.blank?
      @resource_underscored = @resource.split('::')[-1].underscore unless @resource.blank?
      @resource_path = @resource.gsub('::', '/').underscore unless @resource.blank?
      @resource_path_underscored = @resource_path.gsub('/', '_') unless @resource.blank?
      @authenticable = options['authenticable'] ? options['authenticable'].to_sym : nil
    end

    # Sets up some template variables used by the erb templates to prevent to define
    # them in the templates.
    def set_template_variables
      return unless @resource

      @attributes_with_types = attributes_with_types(@resource)
      @required_attributes = @attributes_with_types.keys.map(&:to_s)
    end

    # Generates the api controller.
    def generate_controller
      template 'controller.rb.erb',
               File.join('app/controllers/api',
                         class_path, "#{@resource ? file_name.pluralize : file_name}_controller.rb")
    end

    # Generates the json builders
    def generator_builders
      if @resource
        template 'create.json.jb.erb',
                 File.join('app/views/api', file_path.pluralize, 'create.json.jb')
        template 'update.json.jb.erb',
                 File.join('app/views/api', file_path.pluralize, 'update.json.jb')
        template 'show.json.jb.erb',
                 File.join('app/views/api', file_path.pluralize, 'show.json.jb')
        template 'index.json.jb.erb',
                 File.join('app/views/api', file_path.pluralize, 'index.json.jb')
        template 'search.json.jb.erb',
                 File.join('app/views/api', file_path.pluralize, 'search.json.jb')
      end

      actions.each do |action|
        @current_action = action
        template 'action.json.jb.erb',
                 File.join('app/views/api', file_path, "#{action}.json.jb")
      end
    end

    # Adds the schema hash to the components hash of the swagger_helper
    # if not exists yet.
    def prepare_swagger_schemas
      return unless @resource

      unless File.read('spec/swagger_helper.rb').include? 'components: {'
        inject_into_file 'spec/swagger_helper.rb',
                         before: '      servers: [' do
          "      components: {
      },
"
        end
      end

      return if File.read('spec/swagger_helper.rb').include? 'schemas: {'

      inject_into_file 'spec/swagger_helper.rb',
                         after: '      components: {' do
          "
        schemas: {
        },"
      end
    end


    # Adds the securitySchemes part to the swagger_helper components object.
    def prepare_swagger_security_schemes
      return if File.read('spec/swagger_helper.rb').include? 'securitySchemes: {'

      inject_into_file 'spec/swagger_helper.rb',
                       after: '      components: {' do
        "
        securitySchemes: {
        },"
      end
    end

    # Adds the securitySchemes for authentication to the securitySchemes object.
    def generate_swagger_security_schemes
      return if File.read('spec/swagger_helper.rb').include? 'access_token: {'

      inject_into_file 'spec/swagger_helper.rb',
                       after: '        securitySchemes: {' do
        "
          access_token: {
            type: :apiKey,
            name: 'access-token',
            in: :header
          },
          client: {
            type: :apiKey,
            name: 'client',
            in: :header
          },
          uid: {
            type: :apiKey,
            name: 'uid',
            in: :header
          }"
      end
    end

    # Appends the schema for EzOnRailsRecord to the schemas of swagger_helper
    # if they do not exist yet.
    def generate_swagger_ez_on_rails_schema
      return unless @resource
      return if File.read('spec/swagger_helper.rb').include? 'EzOnRailsRecord'

      # append EzOnRails record if not yet given
      inject_into_file 'spec/swagger_helper.rb',
                       after: '        schemas: {' do
          "
          EzOnRailsRecord: {
            type: :object,
            properties: {
              id: { type: :integer },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' },
              owner_id: { type: :integer, nullable: true }
            }
          },
          RailsFileBlob: {
            type: :object,
            properties: {
              path: { type: :string },
              signed_id: { type: :string },
              filename: { type: :integer }
            }
          },
          UserProfile: {
            type: :object,
            properties: {
              email: { type: :string },
              unconfirmed_email: { type: :string, nullable: true },
              username: { type: :string },
              avatar: { oneOf: [{ '$ref' => '#/components/schemas/RailsFileBlob' }, { type: :null }] }
            }
          },"
      end
    end

    # Appends the schema for search requests to the schemas of swagger_helper
    # if they do not exist yet.
    def generate_swagger_search_schemas
      return unless @resource
      return if File.read('spec/swagger_helper.rb').include? 'SearchFilterComposition'

      inject_into_file 'spec/swagger_helper.rb',
                       after: '        schemas: {' do
          "
          SearchFilter: {
            type: :object,
            properties: {
              field: { type: :string, nullable: true },
              operator: { type: :string, enum: EzOnRails::SearchFilterParser::OPERATOR_MAP.keys },
              value: {
                oneOf: [ { type: :string }, { type: :integer }, { type: :number }, { type: :boolean }, { type: 'null'} ]
              }
            }
          },
          SearchFilterComposition: {
            type: :object,
            properties: {
              logic: { type: :string, enum: ['or', 'and'] },
              filters: {
                type: :array,
                items: {
                  anyOf: [
                    { '$ref' => '#/components/schemas/SearchFilter' },
                    { '$ref' => '#/components/schemas/SearchFilterComposition' }
                  ]
                }
              },
              required: ['logic', 'filters']
            }
          },"
      end
    end

    # Generates the swagger objects used in the intergation spec to generate schemas
    # for the specified resource. If no resource is given, nothing will be generated here.
    # Adds the schemas to the swagger helper wo make it available in the api-docs.
    def generate_swagger_objects
      return unless @resource
      return if File.read('spec/swagger_helper.rb').include? @resource

      # generate properties hash for object
      attrs_with_swagger_types = {}.tap do |attrs_hash|
        @attributes_with_types.each do |attr, type|
          attr_sym = attr.to_sym
          type_sym = type.to_sym

          next attrs_hash[attr_sym] = { type: type_sym, format: 'date' } if type_sym == :date
          next attrs_hash[attr_sym] = { type: type_sym, format: 'date-time' } if type_sym == :datetime
          next attrs_hash[attr_sym] = { type: :number, format: 'float' } if type_sym == :float
          next attrs_hash[attr_sym] = { type: :number, format: 'float' } if type_sym == :decimal
          next attrs_hash[attr_sym] = { type: :number, format: 'double' } if type_sym == :double
          attrs_hash[attr_sym] = { type: type_sym }
        end
      end

      # append swagger schema
      inject_into_file 'spec/swagger_helper.rb',
                       after: '      schemas: {' do
        "
          #{@resource.gsub('::', '')}Properties: {
            type: :object,
            properties: #{pretty_print(attrs_with_swagger_types, 12, ignore_first_indent: true, symbolize_all: true)}
          },
          #{@resource.gsub('::', '')}: {
            type: :object,
            allOf: [
              { '$ref' => '#/components/schemas/EzOnRailsRecord' },
              { '$ref' => '#/components/schemas/#{@resource.gsub('::', '')}Properties' }
            ]
          },"
      end
    end

    # Fix for https://github.com/rswag/rswag/issues/60 .
    def uncomment_infer_spec_type_from_file_location
      gsub_file 'spec/rails_helper.rb',
                "# config.infer_spec_type_from_file_location!",
                "config.infer_spec_type_from_file_location!"
    end

    # Generates integration and request spec.
    # and generating the api documentation using rswag.
    def generate_specs
      # copy the user integration spec if the api generator is called the first time
      copy_file 'spec/integration/api/users_spec.rb',
                'spec/integration/api/users_spec.rb'

      template 'integration_spec.rb.erb',
               File.join('spec', 'integration', 'api', class_path, "#{plural_file_name}_spec.rb")
      template 'request_spec.rb.erb',
               File.join('spec', 'requests', 'api', class_path, "#{plural_file_name}_spec.rb")
    end

    # Generates the routes.
    def generate_routes
      routes = []

      if @resource
        routes += [
          "resources :#{@resource_underscored.pluralize}, except: %i[new edit] do",
          '  collection do',
          '    post :search',
          '  end',
          'end'
        ]
      end

      routes += actions.map { |action| "get '#{file_name}/#{action}', to: '#{file_name}##{action}'" }

      add_routes(routes, ['api'] + class_path, skip_locale: true)
    end

    # Adds the restriction records to the seed.
    def add_restrictions_to_seed
      return unless @authenticable

      append_to_file 'db/seeds.rb', "
# Restrict access to manage #{class_name.pluralize} API
EzOnRails::GroupAccess.find_or_create_by! group: member_group, namespace: '#{ class_path.length > 0 ? (['api'] + class_path).join('/') : 'api' }', controller: '#{@resource ? plural_file_name : file_name}' do |access|
  access.group = member_group
  access.namespace = '#{ class_path.length > 0 ? (['api'] + class_path).join('/') : 'api' }'
  access.controller = '#{@resource ? plural_file_name : file_name}'
end

"
    end


    # Calls rswag to generate the swagger docs.
    def generate_api_docs
      rake 'rswag:specs:swaggerize'
    end
  end
end
