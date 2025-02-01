# frozen_string_literal: true

# The cancancan abilities to defined user access rights.
# To get more information of the acces right system, please
# read the README file of ez_on_rails.
class EzOnRails::Ability
  include CanCan::Ability

  # Constructor takes the current user and defines the abilities for
  # that user.
  def initialize(user)
    # This is necessary because cancancan does not deliver the type of the resource
    # from where the ability class is called. hence we have to allow all first
    # and then lookup which resources are marked as restricted.
    can :manage, :all

    # if this user is admin, skip the abilities, because he should can do anything
    return if user&.super_admin?

    # define ownership_info related abilities, by first allowing nothing if the class is defined
    # and the allowing the things the user has access to
    ownership_infos = EzOnRails::OwnershipInfo.all

    # Restrict first everything if the resource is marked as restricted
    ownership_infos.each do |ownership_info|
      cannot :manage, Class.const_get(ownership_info.resource)
    end

    # allow the things the user has access to
    ownership_abilities user, ownership_infos
    resource_groups_abilities user, ownership_infos
  end

  private

  # Adds the user Abilities related to the ownership and sharing system..
  # If the user is super_admin, he has access to read, write and destroy everything.
  # If the user is assigned as owner to some record, he has access to read, write and destroy.
  # If the user is in a group that is assigned to a resources read-, write- or destroy_accessible_groups
  # the user has access to read, write or destroy the resource.
  # The ownership_infos parameter is expected to be a set of EzOnRails::OwnershipInfos for that the abilities are
  # defined. This is used for performance reasons, because we consider to use this in multiple methods.
  # This method is expected to be called after some other method that already restricted the access to all
  # ownership_info objects.
  def ownership_abilities(user, ownership_infos)
    # For each of them
    ownership_infos.each do |ownership_info|
      # We only want to check ownerships here
      next unless ownership_info.ownerships

      # identify the resource class
      resource_clazz = Class.const_get(ownership_info.resource)

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

  # Adds the abilities to the user related to the resource groups system.
  # If a user is assigned to a group that is flagged as resource_group and the resource is flagged
  # to check the accesses against resource_groups, the user has access to read, write or destroy the resource
  # if the flag is set to the group and the user is assigned to the group and resource.
  # The ownership_infos parameter is expected to be a set of EzOnRails::OwnershipInfos for that the abilities are
  # defined. This is used for performance reasons, because we consider to use this in multiple methods.
  # This method is expected to be called after some other method that already restricted the access to all
  # ownership_info objects.
  def resource_groups_abilities(user, ownership_infos)
    # not logged in user has no access if resource group flag is set
    return if user.nil?

    ownership_infos.each do |ownership_info|
      # We only want to check the resource_groups system
      next unless ownership_info.resource_groups

      # identify the resource class
      resource_clazz = Class.const_get(ownership_info.resource)

      # get resource_groups of the user with read access set
      read_access_assignment_ids = user.user_group_assignments.joins(:group)
                                       .where('group.resource_group': true, 'group.resource_read': true).pluck(:id)
      can :show, resource_clazz, user_group_assignments: { id: read_access_assignment_ids }

      # get resource_groups of the user with read access set
      write_access_assignment_ids = user.user_group_assignments.joins(:group)
                                        .where('group.resource_group': true, 'group.resource_write': true).pluck(:id)
      can :update, resource_clazz, user_group_assignments: { id: write_access_assignment_ids }

      # get resource_groups of the user with read access set
      destroy_access_assignment_ids = user.user_group_assignments.joins(:group)
                                          .where('group.resource_group': true, 'group.resource_destroy': true)
                                          .pluck(:id)
      can :destroy, resource_clazz, user_group_assignments: { id: destroy_access_assignment_ids }
    end
  end
end
