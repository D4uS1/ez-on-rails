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