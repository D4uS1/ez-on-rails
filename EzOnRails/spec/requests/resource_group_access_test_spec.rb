# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

# Spec for testing the access system for resource groups.
describe 'ResourceGroupAccessTestsController' do
  let(:ownership_info) { create(:eor_ownership_info, resource: 'ResourceGroupAccessTest') }
  let(:group) { create(:eor_group, resource_group: true) }
  let(:resource) { create(:resource_group_access_test) }
  let(:other_resource) { create(:resource_group_access_test) }
  let(:andrew) { create(:andrew) }
  let(:john) { create(:john) }
  let(:bob) { create(:bob) }
  let(:admin) { User.super_admin }

  before do
    # we only want to test the resource_groups feature here
    ownership_info.update(ownerships: false, resource_groups: true)

    # user with group assigned to the resource
    create(:eor_user_group_assignment, user: andrew, group: group, resource: resource)

    # user with group assigned to the other resource
    create(:eor_user_group_assignment, user: john, group: group, resource: other_resource)
  end

  context 'when not logged in' do
    let(:ability) { EzOnRails::Ability.new(nil) }

    context 'when having resource_group with read access' do
      before do
        group.update(resource_read: true)
      end

      it 'can not show resource' do
        expect(ability).not_to be_able_to(:show, resource)
      end
    end

    context 'when having resource_group with write access' do
      before do
        group.update(resource_write: true)
      end

      it 'can not update resource' do
        expect(ability).not_to be_able_to(:update, resource)
      end
    end

    context 'when having resource_group with destroy access' do
      before do
        group.update(resource_destroy: true)
      end

      it 'can not destroy resource' do
        expect(ability).not_to be_able_to(:destroy, resource)
      end
    end
  end

  context 'when logged in as user with group assigned to the resource' do
    let(:ability) { EzOnRails::Ability.new(andrew) }

    context 'when having resource_group with read access' do
      before do
        group.update(resource_read: true)
      end

      it 'can show resource' do
        expect(ability).to be_able_to(:show, resource)
      end
    end

    context 'when having resource_group with write access' do
      before do
        group.update(resource_write: true)
      end

      it 'can not update resource' do
        expect(ability).to be_able_to(:update, resource)
      end
    end

    context 'when having resource_group with destroy access' do
      before do
        group.update(resource_destroy: true)
      end

      it 'can not destroy resource' do
        expect(ability).to be_able_to(:destroy, resource)
      end
    end
  end

  context 'when logged in as user with group not assigned to the resource' do
    let(:ability) { EzOnRails::Ability.new(john) }

    context 'when having resource_group with read access' do
      before do
        group.update(resource_read: true)
      end

      it 'can not show resource' do
        expect(ability).not_to be_able_to(:show, resource)
      end
    end

    context 'when having resource_group with write access' do
      before do
        group.update(resource_write: true)
      end

      it 'can not update resource' do
        expect(ability).not_to be_able_to(:update, resource)
      end
    end

    context 'when having resource_group with destroy access' do
      before do
        group.update(resource_destroy: true)
      end

      it 'can not destroy resource' do
        expect(ability).not_to be_able_to(:destroy, resource)
      end
    end
  end

  context 'when logged in as user with group not assigned' do
    let(:ability) { EzOnRails::Ability.new(bob) }

    context 'when having resource_group with read access' do
      before do
        group.update(resource_read: true)
      end

      it 'can not show resource' do
        expect(ability).not_to be_able_to(:show, resource)
      end
    end

    context 'when having resource_group with write access' do
      before do
        group.update(resource_write: true)
      end

      it 'can not update resource' do
        expect(ability).not_to be_able_to(:update, resource)
      end
    end

    context 'when having resource_group with destroy access' do
      before do
        group.update(resource_destroy: true)
      end

      it 'can not destroy resource' do
        expect(ability).not_to be_able_to(:destroy, resource)
      end
    end
  end

  context 'when logged in as super admin' do
    let(:ability) { EzOnRails::Ability.new(admin) }

    context 'when having resource_group with read access' do
      before do
        group.update(resource_read: true)
      end

      it 'can not show resource' do
        expect(ability).to be_able_to(:show, resource)
      end
    end

    context 'when having resource_group with write access' do
      before do
        group.update(resource_write: true)
      end

      it 'can not update resource' do
        expect(ability).to be_able_to(:update, resource)
      end
    end

    context 'when having resource_group with destroy access' do
      before do
        group.update(resource_destroy: true)
      end

      it 'can not destroy resource' do
        expect(ability).to be_able_to(:destroy, resource)
      end
    end
  end
end
