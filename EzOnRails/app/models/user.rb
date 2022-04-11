# frozen_string_literal: true

# User class defining a user of the application.
class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User

  SUPER_ADMIN_USERNAME = 'SuperAdministrator'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable,
         :confirmable,
         omniauth_providers: Devise.omniauth_configs.keys

  has_many :user_group_assignments, class_name: 'EzOnRails::UserGroupAssignment', dependent: :delete_all
  has_many :groups, class_name: 'EzOnRails::Group', through: :user_group_assignments
  has_one :user_group, dependent: :delete, class_name: 'EzOnRails::Group'

  # Oauth provider
  has_many  :access_grants, class_name: 'Doorkeeper::AccessGrant',
                            foreign_key: :resource_owner_id,
                            dependent: :delete_all
  has_many  :access_tokens, class_name: 'Doorkeeper::AccessToken',
                            foreign_key: :resource_owner_id,
                            dependent: :delete_all

  # Active storage
  has_one_attached :avatar

  validates :email, presence: true, uniqueness: true
  validates :privacy_policy_accepted, presence: true
  validates_with EzOnRails::UserGroupNameValidator, if: -> { email_was.empty? || email_was != email }

  after_create :create_user_group
  after_create :assign_to_member_group
  before_update :validate_update
  before_update :update_user_group
  before_destroy :validate_destroy, prepend: true
  before_destroy :cascade_owned_resources
  before_destroy :destroy_member_group_assignment

  # Returns the member group
  def self.super_admin
    find_by(username: SUPER_ADMIN_USERNAME)
  end

  # Returns wether the current user is administrator.
  def super_admin?
    EzOnRails::UserGroupAssignment.find_by(user: self, group: EzOnRails::Group.super_admin_group) != nil
  end

  # Saves the current user without having a password and having an omniauth_uid and omniauth_provider,.
  # Creates a password by devise.
  # This method can be used by omniauth to create a user without having a password.
  def save_with_omniauth
    return false if !provider || !uid

    self.password = Devise.friendly_token[0, 20]

    save
  end

  # Returns the user of the given omniauth information if it exists.
  # If it does not exists, it returns an user object having the user data passed by omniauth
  # that is not persisted yet.
  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)

    return user if user

    User.new(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      username: auth.info.username || auth.info.name,
      confirmed_at: DateTime.now
    )
  end

  # Called from the registration controller before creating a resource.
  # Needed by some oauth provider to copy
  # data from the session to the user model.
  def self.new_with_session(params, session)
    super.tap do |user|
      # Do some
      # if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
      #  user.email = data["email"] if user.email.blank?
      # end
    end
  end

  # Returns the user group name of this user.
  # The user group name is per default the email.
  def user_group_name
    email
  end

  # Overwrites the as_json method by calling super and appending the avatar_url to
  # provide the avatar image after login.
  def as_json(options)
    super(options).merge({
                           avatar_url: if avatar.attached?
                                         Rails.application.routes.url_helpers.rails_blob_url(
                                           avatar, only_path: true
                                         )
                                       end
                         })
  end

  private

  # Performs an cascading action on the owned resource of the user if the user is destroyed.
  # This depends on the on_owner_destroy value set in the OwnerShipInfo.
  # If the value is set to "nullify", the reference will be removed.
  # If the value is set to "destroy", the destroy method will be called on each owned resource.
  # If the value is set to "delete", the owned record will be deleted without calling hooks and validations.
  def cascade_owned_resources
    ownership_infos = EzOnRails::OwnershipInfo.all

    ownership_infos.each do |ownership_info|
      # identify the class of the resource
      resource_class = ownership_info.resource_class

      # get all records owned by the user
      resource_class.where(owner: self).find_each do |resource|
        # perform action depending on the configured action
        next resource.destroy if ownership_info.resource_destroy?
        next resource.delete if ownership_info.resource_delete?

        resource.update(owner: nil)
      end
    end
  end

  # Destroys the member group assignment of this user.
  # Needed because the validator of group assignments is also called in dependent destroy relations.
  # Hence the member group assignment will not be deleted.
  def destroy_member_group_assignment
    user_group_assignments.each do |user_group_assignment|
      user_group_assignment.delete if user_group_assignment.group.member_group?
    end
  end

  # Creates a group having the same name like the user.
  # The group is assigned to this user.
  def create_user_group
    self.user_group = EzOnRails::Group.create(name: user_group_name, user: self, users: [self])
  end

  # Changes the name of the user group if the user name was changed.
  def update_user_group
    user_group.update(name: user_group_name)
  end

  # Assigns the created user to the member group
  def assign_to_member_group
    EzOnRails::UserGroupAssignment.create(user: self, group: EzOnRails::Group.member_group)
  end

  # Validates if this resource is destroyable.
  def validate_destroy
    return unless super_admin?

    errors.add(:base, I18n.t(:admin_user_not_destroyable))
    throw(:abort)
  end

  # Validates if this resource is updatable.
  # The resource is not updatable if this is the super administrator user and the name was changed.
  def validate_update
    return unless username_was == SUPER_ADMIN_USERNAME && username != SUPER_ADMIN_USERNAME

    errors.add(:base, I18n.t(:admin_user_not_updatable))
    throw(:abort)
  end
end
