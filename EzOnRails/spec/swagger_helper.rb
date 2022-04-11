# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'www.example.com'
            }
          }
        }
      ],
      components: {
        schemas: {
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
          }
        },
        securitySchemes: {
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
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
