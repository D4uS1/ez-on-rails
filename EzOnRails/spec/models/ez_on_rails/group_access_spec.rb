# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EzOnRails::GroupAccess, type: :model do
  let(:group_access_attributes) do
    {
      namespace: 'ez_on_rails/admin/user_management',
      controller: 'dashboard',
      action: 'index',
      group_id: EzOnRails::Group.member_group.id
    }
  end

  context 'when validating' do
    it 'creates valid record' do
      expect(described_class.create(group_access_attributes)).to be_valid
    end

    it 'requires group' do
      expect(described_class.create(
               group_access_attributes.merge(group_id: nil)
             )).to be_invalid
    end

    it 'is unique access' do
      described_class.create(group_access_attributes)

      expect(described_class.create(group_access_attributes)).to be_invalid
    end

    it 'rejects invalid route' do
      expect(described_class.create(
               group_access_attributes.merge(controller: 'not_dashboard')
             )).to be_invalid
    end

    it 'accepts namespace only' do
      expect(described_class.create(
               group_access_attributes.merge(namespace: 'ez_on_rails', controller: nil, action: nil)
             )).to be_valid
    end

    it 'accepts nested namespace' do
      expect(described_class.create(
               group_access_attributes.merge(namespace: 'ez_on_rails/admin', controller: nil, action: nil)
             )).to be_valid
    end

    it 'accepts controller only' do
      expect(described_class.create(
               group_access_attributes.merge(namespace: nil, controller: 'access_test', action: nil)
             )).to be_valid
    end

    it 'rejects action only' do
      expect(described_class.create(
               group_access_attributes.merge(namespace: nil, controller: nil, action: 'index')
             )).to be_invalid
    end

    it 'accepts namespace and controller only' do
      expect(described_class.create(
               group_access_attributes.merge(namespace: 'namespaced', controller: 'access_test', action: nil)
             )).to be_valid
    end

    it 'does not accept action and namespace only' do
      expect(described_class.create(
               group_access_attributes.merge(namespace: 'ez_on_rails/admin', controller: nil, action: 'index')
             )).to be_invalid
    end

    it 'does not accept namespaces in action' do
      expect(described_class.create(
               group_access_attributes.merge(namespace: 'ez_on_rails', controller: 'admin', action: 'dashboard/index')
             )).to be_invalid
    end

    it 'does not accept namespaces in controller' do
      expect(described_class.create(
               group_access_attributes.merge(namespace: 'ez_on_rails', controller: 'admin/dashboard', action: 'index')
             )).to be_invalid
    end
  end

  context 'when using hooks' do
    it 'revises name of resource' do
      access = described_class.create!(
        namespace: 'EzOnRails::Admin::UserManagement',
        controller: 'Dashboard',
        action: 'index',
        group_id: EzOnRails::Group.member_group.id
      )

      expect(access).to be_valid
      expect(access.namespace).to eq('ez_on_rails/admin/user_management')
      expect(access.controller).to eq('dashboard')
      expect(access.action).to eq('index')
    end

    it 'removes starting and trailing slashes' do
      access = described_class.create!(
        namespace: '/ez_on_rails/admin/user_management/',
        controller: '/dashboard/',
        action: '/index/',
        group_id: EzOnRails::Group.member_group.id
      )

      expect(access).to be_valid
      expect(access.namespace).to eq('ez_on_rails/admin/user_management')
      expect(access.controller).to eq('dashboard')
      expect(access.action).to eq('index')
    end

    it 'can not update admin area access' do
      admin_access = described_class.admin_area

      expect(admin_access.update(
               namespace: group_access_attributes[:namespace],
               controller: group_access_attributes[:controller],
               action: group_access_attributes[:action]
             )).to be(false)
    end

    it 'can not destroy admin area access' do
      expect(described_class.admin_area.destroy).to be(false)
    end
  end
end
