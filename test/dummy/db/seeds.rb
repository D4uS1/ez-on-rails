# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# initial admin and member group
super_admin_group = EzOnRails::Group.find_or_create_by! name: EzOnRails::Group::SUPER_ADMIN_GROUP_NAME do |group|
  group.name = EzOnRails::Group::SUPER_ADMIN_GROUP_NAME
end
member_group = EzOnRails::Group.find_or_create_by! name: EzOnRails::Group::MEMBER_GROUP_NAME do |group|
  group.name = EzOnRails::Group::MEMBER_GROUP_NAME
end
api_key_group = EzOnRails::Group.find_or_create_by! name: EzOnRails::Group::API_KEY_GROUP_NAME do |group|
  group.name = EzOnRails::Group::API_KEY_GROUP_NAME
end

# initial admin user
super_admin_user = User.find_or_create_by! username: User::SUPER_ADMIN_USERNAME do |user|
  user.username = User::SUPER_ADMIN_USERNAME
  user.email = 'administrator@example.com'
  user.password = '1replace_me3_after3_install7'
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

# Restrict access to manage ParentFormTests
EzOnRails::GroupAccess.find_or_create_by! group: super_admin_group, controller: 'parent_form_tests' do |access|
  access.group = super_admin_group
  access.controller = 'parent_form_tests'
end

# Restrict access to manage NestedFormTests
EzOnRails::GroupAccess.find_or_create_by! group: super_admin_group, controller: 'nested_form_tests' do |access|
  access.group = super_admin_group
  access.controller = 'nested_form_tests'
end

# Restrict access to manage AssocTests
EzOnRails::GroupAccess.find_or_create_by! group: super_admin_group, controller: 'assoc_tests' do |access|
  access.group = super_admin_group
  access.controller = 'assoc_tests'
end

# Restrict access to manage PropertiesTests
EzOnRails::GroupAccess.find_or_create_by! group: super_admin_group, controller: 'properties_tests' do |access|
  access.group = super_admin_group
  access.controller = 'properties_tests'
end

# Restrict access to manage ResourceGroupAccessTests
EzOnRails::GroupAccess.find_or_create_by! group: super_admin_group, controller: 'resource_group_access_tests' do |access|
  access.group = super_admin_group
  access.controller = 'resource_group_access_tests'
end

# Restrict access to manage ApiKeyTests
EzOnRails::GroupAccess.find_or_create_by! group: super_admin_group, controller: 'api_key_tests' do |access|
  access.group = super_admin_group
  access.controller = 'api_key_tests'
end

# Restrict access to manage ApiKeyTests API
EzOnRails::GroupAccess.find_or_create_by! group: member_group, namespace: 'api', controller: 'api_key_tests' do |access|
  access.group = api_key_group
  access.namespace = 'api'
  access.controller = 'api_key_tests'
end
