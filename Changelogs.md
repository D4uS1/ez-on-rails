# Changelogs
## 0.8.1
* Added __association_show_label__ to render_info. Have a look at the "Associations" section in the [render info](https://github.com/D4uS1/ez-on-rails/wiki/Render-Info) documentation for details.
* Added __association_search_attributes__ to render_info. Have a look at the "Customize Search" section in the [render info](https://github.com/D4uS1/ez-on-rails/wiki/Render-Info) documentation for details.
* Added possibility to define association collections using the __data__ attribute in the render info
* Added __polymorphic_association__ as field type to the render info. Have a look at the "Polymorphic associations" section in the [render info](https://github.com/D4uS1/ez-on-rails/wiki/Render-Info) documentation for details.
* Added possibility to use stimulus controllers. Have a look at the sections for model_forms in the  [partials](https://github.com/D4uS1/ez-on-rails/wiki/Partials) documentation for details.
* Moved __invalid_request_type__ that raises an 406 error to the application controller. Added __json_request?__ and __html_request?__ methods to application controlller. See [this article](https://github.com/D4uS1/ez-on-rails/wiki/Reject-invalid-request-types) for details.
* Renamed __EzOnRails::ApiError__ to __EzOnRails::Error__ and moved error catching from api controller to application controller.