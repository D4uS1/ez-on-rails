# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|de/ do
    namespace :ez_on_rails do
      scope module: 'admin', path: 'admin' do
        get 'dashboard/', to: 'dashboard#index'

        scope module: 'broom_closet', path: 'broom_closet' do
          get 'dashboard/', to: 'dashboard#index'
          get 'nil_owners/', to: 'nil_owners#index'
          post 'nil_owners/search'
          get 'nil_owners/search'
          delete 'nil_owners/destroy_all'
          delete 'nil_owners/destroy_selections'
          get 'unattached_files/', to: 'unattached_files#index'
          post 'unattached_files/search'
          get 'unattached_files/search'
          delete 'unattached_files/destroy_all'
          delete 'unattached_files/destroy_selections'
        end

        scope module: 'user_management', path: 'user_management' do
          get 'dashboard/', to: 'dashboard#index'
          resources :groups do
            collection do
              match 'search' => 'groups#search', via: %i[get post], as: :search
              delete 'destroy_selections'
            end
          end
          resources :user_group_assignments do
            collection do
              match 'search' => 'user_group_assignments#search', via: %i[get post], as: :search
              delete 'destroy_selections'
            end
          end
          resources :group_accesses do
            collection do
              match 'search' => 'group_accesses#search', via: %i[get post], as: :search
              delete 'destroy_selections'
            end
          end
          resources :resource_read_accesses do
            collection do
              match 'search' => 'resource_read_accesses#search', via: %i[get post], as: :search
              delete 'destroy_selections'
            end
          end
          resources :resource_write_accesses do
            collection do
              match 'search' => 'resource_write_accesses#search', via: %i[get post], as: :search
              delete 'destroy_selections'
            end
          end
          resources :resource_destroy_accesses do
            collection do
              match 'search' => 'resource_destroy_accesses#search', via: %i[get post], as: :search
              delete 'destroy_selections'
            end
          end
          resources :users do
            member do
              get 'password_reset', to: 'users#password_reset'
              patch 'password_reset', to: 'users#update_password'
            end
            collection do
              match 'search' => 'users#search', via: %i[get post], as: :search
              delete 'destroy_selections'
            end
          end
          resources :ownership_infos do
            collection do
              match 'search' => 'ownership_infos#search', via: %i[get post], as: :search
              delete 'destroy_selections'
            end
          end
        end
      end

      namespace :active_storage do
        resources :blobs, param: :signed_id, only: [:destroy] do
          collection do
            post 'create_direct_upload'
          end
        end
      end
    end

    # added to make references to users available directly
    resources :users, only: [:show], controller: 'ez_on_rails/admin/user_management/users'

    get 'welcome/', to: 'welcome#index'
    get 'privacy_policy/', to: 'privacy_policy#index'
    get 'imprint/', to: 'imprint#index'
    get 'contact_form/', to: 'contact_form#index'
    post 'contact_form/submit'
    get 'contact_form/submit'

    root 'welcome#index'
  end

  namespace :api do
    # for oauth_provider
    namespace :auth do
      get 'email_users/profile', to: 'email_users#profile'
    end

    # for users
    get 'users/me', to: 'users#me'
    patch 'users/me', to: 'users#update_me'

    # for active storage additional actions
    namespace :active_storage do
      resources :blobs, param: :signed_id, only: [:destroy] do
        collection do
          post 'create_direct_upload'
        end
      end
    end
  end
end
