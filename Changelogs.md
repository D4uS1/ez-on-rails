# Changelogs
## 0.8.1
* Added __association_show_label__ to render_info. Have a look at the "Associations" section in the [render info](https://github.com/D4uS1/ez-on-rails/wiki/Render-Info) documentation for details.
* Added __association_search_attributes__ to render_info. Have a look at the "Customize Search" section in the [render info](https://github.com/D4uS1/ez-on-rails/wiki/Render-Info) documentation for details.
* Added possibility to define association collections using the __data__ attribute in the render info
* Added __polymorphic_association__ as field type to the render info. Have a look at the "Polymorphic associations" section in the [render info](https://github.com/D4uS1/ez-on-rails/wiki/Render-Info) documentation for details.
* Added possibility to use stimulus controllers and passing values to it. Have a look at the sections for model_forms in the  [partials](https://github.com/D4uS1/ez-on-rails/wiki/Partials) documentation for details.
* Moved __invalid_request_type__ that raises an 406 error to the application controller. Added __json_request?__ and __html_request?__ methods to application controlller. See [this article](https://github.com/D4uS1/ez-on-rails/wiki/Reject-invalid-request-types) for details.
* Renamed __EzOnRails::ApiError__ to __EzOnRails::Error__ and moved error catching from api controller to application controller.

## 0.9.0
* Updated rails dependency to be at least 7.2.1

## 1.0.0
* Updated engine structure including its test application to match the rails recommended way
* The Gem can now be fetched via bundler without defining a glob to a subfolder of this repository

## 1.1.0
* Updated ruby version to 3.3.7
* Updated rails to 8.0.1 and update dependencies to newest versions
* Removed image_processing and mini_magick dependency, since it should be installed by the host application if needed
* Removed omniauth-gitlab dependency, since it should be installed by the host application if needed

## 1.1.1
* Removed sprockets dependency and added propshaft as dependency for asset pipeline

## 1.1.2
* Changed data field in the attribute_render_info for enum_fields to be an optional object
* Added possibility to make enums nullable by adding __nullable: true__ to the :data objet in its attribute_render_info
* Moved alternative enum_name field from :data to a field of the :data object, called :enum_name, in the attribute_render_info of the enum_field

## 1.1.3
* Changed flag in language switcher for english to the flag of the European Union

## 1.1.4
* Added optional "search all" field in search form

## 1.1.5
* Added go-to links for nested objects in the show action
  * Can be disabled by passing __hide_nested_goto: true__ to the data of the field holding the nested object in the __render_info__

## 1.2.0
* Added possibility to create api keys to grant access to restricted resources without the need of user accounts

# Update Steps
## From 1.1.x to 1.2.0
1. Create migration file to generate api_keys, having the following content
```
class CreateApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :eor_api_keys do |t|
      t.string :api_key, null: false
      t.datetime :expires_at

      t.belongs_to :owner, index: true, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :eor_api_keys,
              [:api_key],
              unique: true,
              name: 'eor_api_keys_index'
  end
end
```

2. Add the creation of the group to use api keys to the seeds. You can add it beyond the creation of the member_group.
```
api_key_group = EzOnRails::Group.find_or_create_by! name: EzOnRails::Group::API_KEY_GROUP_NAME do |group|
  group.name = EzOnRails::Group::API_KEY_GROUP_NAME
end
```

3. Migrate the database and seed
```
rails db:migrate
rails db:seed
```

4. Add the api key to the security schemas in __swagger_helper.rb__
```
...
securitySchemes: {
...
  api_key: {
    type: :apiKey,
    name: 'api-key',
    in: :header
  }
}
...
```

## 1.2.1
* Added methods protected method __additional_permit_params__ to controllers to provide additional parameters that are passed to rails params.expect function
  * This is useful for eg. json fields having object or array data that needs to be permitted
* Removed auto permit of parameters that use the __:json__ type in the render_info
* Added __active_storage_relation_names__ method to EzOnRails::ApplicationRecord that returns all names of active storage attachment relations
* Added __wrapped_parameter_names__ method to EzOnRails::ApplicationRecord that can be used to get all parameters that should be wrapped using rails wrap_parameters callback in controllers, including active storage fields.
  * The ezapi generator adds the call for the wrapper automatically, if you want to add it to existing controllers, add the following lines
```
  # Fixes that rails does not include active storage fields in the parameter wrapper
  wrap_parameters :your_record_name_underscored, include: YourModelClass.wrapped_parameter_names
```
