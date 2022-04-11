# frozen_string_literal: true

# The cancancan abilities to defined user access rights.
# To get more information of the acces right system, please
# read the README file of ez_on_rails.
class EzOnRails::Ability
  include CanCan::Ability

  # Constructor takes the current user and defines the abilities for
  # that user.
  def initialize(user)
    ownership_infos_abilities user
  end

  private

  # Adds the user owned Model Abilities to the specified user.
  def ownership_infos_abilities(user)
    # This is necessary because cancancan does not deliver the type of the resource
    # from where the ability class is called. hence we have to allow all first
    # and then lookup which resources are marked as restricted.
    can :manage, :all

    # if this user is admin, skip the abilities, because he should can do anything
    return if user&.super_admin?

    # get all user owned models
    ownership_infos = EzOnRails::OwnershipInfo.all

    # For each of them
    ownership_infos.each do |ownership_info|
      # Identify class
      resource_clazz = Class.const_get(ownership_info.resource)

      # Restrict first everything if the resource is marked as restricted
      cannot :manage, resource_clazz

      # user can manage if it is noones resource
      can :manage, resource_clazz, owner: nil

      next if user.nil?

      # user can manage if it is his own resource
      can :manage, resource_clazz, owner: user

      next unless ownership_info.sharable

      # user can show if he is in the groups that have read access to the resource
      can :show, resource_clazz, read_accessible_groups: { id: user.group_ids }

      # user can update if he is in the groups that have write access to the resource
      can :update, resource_clazz, write_accessible_groups: { id: user.group_ids }

      # user can destroy if he is in the groups that have destroy access to the resource
      can :destroy, resource_clazz, destroy_accessible_groups: { id: user.group_ids }
    end
  end
end
