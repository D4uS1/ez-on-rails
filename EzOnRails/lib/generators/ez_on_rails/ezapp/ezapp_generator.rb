# frozen_string_literal: true

require 'rails/generators'

module EzOnRails
  # Generator for creating a web application, containing user management, basic navigation and
  # many partials for rendering default scaffolds and more.
  # Please read the README file for further information.
  class EzappGenerator < Rails::Generators::NamedBase

    source_root File.expand_path('templates', __dir__)

    # installs ruby dependencies
    def install_ruby_deps
      generate 'rswag:install'

      generate 'simple_form:install --bootstrap'
      generate 'rspec:install'
      generate 'devise:install'

      rake 'active_storage:install'
    end

    # Generates the migrations for the user management.
    def generate_migrations
      now = DateTime.now
      now_string = now.year.to_s +
                   (now.month  < 10 ? ('0' + now.month.to_s)  : now.month.to_s) +
                   (now.day    < 10 ? ('0' + now.day.to_s)    : now.day.to_s)   +
                   (now.hour   < 10 ? ('0' + now.hour.to_s)   : now.hour.to_s)  +
                   (now.minute < 10 ? ('0' + now.minute.to_s) : now.minute.to_s)

      copy_file 'db/migrate/devise_create_users.rb',
                "db/migrate/#{now_string + '01'}_devise_create_users.rb"
      template 'db/migrate/create_groups.rb.erb',
               "db/migrate/#{now_string + '03'}_create_groups.rb"
      template 'db/migrate/create_user_group_assignments.rb.erb',
                "db/migrate/#{now_string + '04'}_create_user_group_assignments.rb"
      template 'db/migrate/create_group_accesses.rb.erb',
                "db/migrate/#{now_string + '05'}_create_group_accesses.rb"
      template 'db/migrate/create_ownership_infos.rb.erb',
                "db/migrate/#{now_string + '06'}_create_ownership_infos.rb"
      template 'db/migrate/create_resource_read_accesses.rb.erb',
               "db/migrate/#{now_string + '07'}_create_resource_read_accesses.rb"
      template 'db/migrate/create_resource_write_accesses.rb.erb',
               "db/migrate/#{now_string + '08'}_create_resource_write_accesses.rb"
      template 'db/migrate/create_resource_destroy_accesses.rb.erb',
               "db/migrate/#{now_string + '09'}_create_resource_destroy_accesses.rb"
      copy_file 'db/migrate/create_doorkeeper_tables.rb',
                "db/migrate/#{now_string + '10'}_create_doorkeeper_tables.rb"
    end

    # Appends the seeds fo the user management.
    def generate_seeds
      append_to_file 'db/seeds.rb', "
# initial admin and member group
super_admin_group = EzOnRails::Group.find_or_create_by! name: EzOnRails::Group::SUPER_ADMIN_GROUP_NAME do |group|
  group.name = EzOnRails::Group::SUPER_ADMIN_GROUP_NAME
end
member_group = EzOnRails::Group.find_or_create_by! name: EzOnRails::Group::MEMBER_GROUP_NAME do |group|
  group.name = EzOnRails::Group::MEMBER_GROUP_NAME
end

# initial admin user
super_admin_user = User.find_or_create_by! username: User::SUPER_ADMIN_USERNAME do |user|
  user.username = User::SUPER_ADMIN_USERNAME
  user.email = 'administrator@example.com'
  user.password = '#{SecureRandom.alphanumeric(64)}'
  user.confirmed_at = DateTime.now
  user.privacy_policy_accepted = true
end

# initial admin group assignment and access
EzOnRails::UserGroupAssignment.find_or_create_by! user: super_admin_user, group: super_admin_group do |group_assignment|
  group_assignment.user = super_admin_user
  group_assignment.group = super_admin_group
end
EzOnRails::UserGroupAssignment.find_or_create_by! user: super_admin_user, group: member_group do |group_assignment|
  group_assignment.user = super_admin_user
  group_assignment.group = member_group
end
EzOnRails::GroupAccess.find_or_create_by! group: super_admin_group, namespace: EzOnRails::GroupAccess::ADMIN_AREA_NAMESPACE do |group_access|
  group_access.group = super_admin_group
  group_access.namespace = EzOnRails::GroupAccess::ADMIN_AREA_NAMESPACE
end

# initial active storage rights
EzOnRails::GroupAccess.find_or_create_by! group: member_group, namespace: 'api/active_storage', controller: 'blobs' do |group_access|
  group_access.group = member_group
  group_access.namespace = 'api/active_storage'
  group_access.controller = 'blobs'
end
EzOnRails::GroupAccess.find_or_create_by! group: member_group, namespace: 'ez_on_rails/active_storage', controller: 'blobs' do |group_access|
  group_access.group = member_group
  group_access.namespace = 'ez_on_rails/active_storage'
  group_access.controller = 'blobs'
end

# Restrict access to users API
EzOnRails::GroupAccess.find_or_create_by! group: member_group, namespace: 'api', controller: 'users' do |access|
  access.group = member_group
  access.namespace = 'api'
  access.controller = 'users'
end
"
    end

    # Copies the initializer whhich loads the navigation at startup,
    # and the navigation json file.
    def generate_navigation_files
      template 'menu_structure_helper.rb.erb', 'app/helpers/ez_on_rails/menu_structure_helper.rb'
    end

    # Generates the layout toggle helper to toogle some layout specific options.
    def generate_layout_helpers
      template 'helpers/ez_on_rails/layout_toggle_helper.rb', 'app/helpers/ez_on_rails/layout_toggle_helper.rb'
      template 'helpers/ez_on_rails/layout_helper.rb', 'app/helpers/ez_on_rails/layout_helper.rb'
    end

    # Writes data to config.
    def generate_config
      directory 'config', 'config'

      inject_into_file 'config/environments/development.rb',
                       after: 'Rails.application.configure do' do
        "\n  # Devise
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }\n"
      end

      inject_into_file 'config/environments/production.rb',
                       after: 'Rails.application.configure do' do
        "\n  # Devise
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }\n"
      end

      inject_into_file 'config/environments/test.rb', after: 'Rails.application.configure do' do
        "\n  # Devise
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }\n
  \n
  # For RSpec Testing\n
  Rails.application.routes.default_url_options = { host: 'localhost', port: 3000 }\n"
      end

      gsub_file 'config/initializers/devise.rb',
                "# config.parent_controller = 'DeviseController'",
                "config.parent_controller = 'EzOnRails::ApplicationController'"

      gsub_file 'config/initializers/devise.rb',
                "# config.reload_routes = true",
                "config.reload_routes = false"

      gsub_file 'config/initializers/devise.rb',
                "# config.scoped_views = false",
                "config.scoped_views = true"

      gsub_file 'config/initializers/devise.rb',
                "# config.default_scope = :user",
                "config.default_scope = :user"
    end

    # Generates the routes for devise, doorkeeper and devise_token_auth, because they will cause
    # Errors if we try to boot without devise:install being called before.
    # Hence, we can not generate ezapp with havinbg the routes defines.
    def generate_routes
      route "
  ## The following routes were generated by ez_on_rails:ezapp.
  scope '(:locale)', locale: /en|de/ do
    devise_for :users, controllers: {
      confirmations: 'users/confirmations',
      passwords: 'users/passwords',
      registrations: 'users/registrations',
      sessions: 'users/sessions',
      unlocks: 'users/unlocks'
    }, skip: [:omniauth_callbacks]

    devise_scope :user do
      post 'users/omniauth_sign_up', to: 'users/registrations#omniauth_create'
    end
  end

  # needed here because the omniauth callbacks do not support scopes
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }, skip: %i[confirmations passwords registrations sessions unlocks]

  namespace :api do
     mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      omniauth_callbacks: 'api/auth/omniauth_callbacks'
    }
  end

  use_doorkeeper

  scope ActiveStorage.routes_prefix do
    get '/blobs/redirect/:signed_id/*filename', to: 'active_storage/blobs/redirect#show', as: :rails_service_blob
    # get '/blobs/proxy/:signed_id/*filename', to: 'active_storage/blobs/proxy#show', as: :rails_service_blob_proxy
    get '/blobs/:signed_id/*filename', to: 'active_storage/blobs/redirect#show'

    # get '/representations/redirect/:signed_blob_id/:variation_key/*filename',
    #     to: 'active_storage/representations/redirect#show',
    #     as: :rails_blob_representation
    # get '/representations/proxy/:signed_blob_id/:variation_key/*filename',
    #     to: 'active_storage/representations/proxy#show',
    #     as: :rails_blob_representation_proxy
    # get '/representations/:signed_blob_id/:variation_key/*filename',
    #     to: 'active_storage/representations/redirect#show'

    unless Rails.env.production?
      get  '/disk/:encoded_key/*filename' => 'active_storage/disk#show', as: :rails_disk_service
      put  '/disk/:encoded_token' => 'active_storage/disk#update', as: :update_rails_disk_service
    end
    # post '/direct_uploads' => 'active_storage/direct_uploads#create', as: :rails_direct_uploads
  end

  # direct :rails_representation do |representation, options|
  #    route_for(ActiveStorage.resolve_model_to_route, representation, options)
  # end

  # resolve('ActiveStorage::Variant') do |variant, options|
  #   route_for(ActiveStorage.resolve_model_to_route, variant, options)
  #  end
  # resolve('ActiveStorage::VariantWithRecord') do |variant, options|
  #   route_for(ActiveStorage.resolve_model_to_route, variant, options)
  # end
  # resolve('ActiveStorage::Preview') do |preview, options|
  #   route_for(ActiveStorage.resolve_model_to_route, preview, options)
  # end

  direct :rails_blob do |blob, options|
    route_for(ActiveStorage.resolve_model_to_route, blob, options)
  end

  resolve('ActiveStorage::Blob') do |blob, options|
    route_for(ActiveStorage.resolve_model_to_route, blob, options)
  end
  resolve('ActiveStorage::Attachment') do |attachment, options|
    route_for(ActiveStorage.resolve_model_to_route, attachment.blob, options)
  end

  # direct :rails_storage_proxy do |model, options|
  #   if model.respond_to?(:signed_id)
  #     route_for(:rails_service_blob_proxy, model.signed_id, model.filename, options)
  #   else
  #     route_for(:rails_blob_representation_proxy,
  #               model.blob.signed_id,
  #               model.variation.key,
  #               model.blob.filename,
  #               options)
  #   end
  # end

  direct :rails_storage_redirect do |model, options|
    if model.respond_to?(:signed_id)
      route_for(:rails_service_blob, model.signed_id, model.filename, options)
    else
      route_for(:rails_blob_representation, model.blob.signed_id, model.variation.key, model.blob.filename, options)
    end
  end
  ## End of ez_on_rails:ezapp routes

"
    end

    # Replaces the commented line including all support files in the spec helper
    # with the uncommented version.
    def modify_rails_spec_helper
      gsub_file 'spec/rails_helper.rb',
                "# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }",
                "Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }"
    end

    # Copy the support spec files of ez_on_rails.
    def copy_spec_support_file
      directory 'spec/support', 'spec/support'
    end

    # Generate Navigation
    def print_finish_message
      print "App creation successful. Dont forget to migrate and seed the database.\n"
    end
  end
end
