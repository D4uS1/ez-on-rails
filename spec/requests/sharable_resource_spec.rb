# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

# Spec for testing the access system for sharable ownership infos.
# Will test wether non logged in users does not have access to shared resources.
# Also tests wether a logged in user without shared access (bob here) has no acces to the resource.
# The owner (andrew here), will habe access to manage the resource.
# A user with shared read access (christoph here), will have to show the resource.
# A user with shared write access (john here), will have to update the resource.
# A user with shared destroy access (florian here), will have to destroy the resource.
describe 'SharableResourcesController' do
  let(:readable_group) do
    create(:eor_group, name: 'Readable')
  end
  let(:writable_group) do
    create(:eor_group, name: 'Writable')
  end
  let(:destroyable_group) do
    create(:eor_group, name: 'Destroyable')
  end

  let(:bob) do
    create(:bob)
  end
  let(:andrew) do
    create(:andrew)
  end
  let(:christoph) do
    create(:christoph, groups: [readable_group])
  end
  let(:john) do
    create(:john, groups: [writable_group])
  end
  let(:florian) do
    create(:florian, groups: [destroyable_group])
  end
  let(:admin) do
    User.super_admin
  end

  let(:sharable_resource) do
    create(:sharable_resource,
           owner: andrew,
           read_accessible_groups: [readable_group],
           write_accessible_groups: [writable_group],
           destroy_accessible_groups: [destroyable_group])
  end

  before do
    create(:eor_ownership_info, resource: 'SharableResource', ownerships: true, sharable: true)
  end

  context 'when not logged in' do
    let(:ability) { EzOnRails::Ability.new(nil) }

    it 'can not show shared resource' do
      expect(ability).not_to be_able_to(:show, sharable_resource)
    end

    it 'can not update shared resource' do
      expect(ability).not_to be_able_to(:update, sharable_resource)
    end

    it 'can not destroy shared resource' do
      expect(ability).not_to be_able_to(:destroy, sharable_resource)
    end
  end

  context 'when logged in as user without shared access' do
    let(:ability) { EzOnRails::Ability.new(bob) }

    it 'can not show shared resource' do
      expect(ability).not_to be_able_to(:show, sharable_resource)
    end

    it 'can not update shared resource' do
      expect(ability).not_to be_able_to(:update, sharable_resource)
    end

    it 'can not destroy shared resource' do
      expect(ability).not_to be_able_to(:destroy, sharable_resource)
    end
  end

  context 'when logged in as owner of the resource' do
    let(:ability) { EzOnRails::Ability.new(andrew) }

    it 'can show shared resource' do
      expect(ability).to be_able_to(:show, sharable_resource)
    end

    it 'can update shared resource' do
      expect(ability).to be_able_to(:update, sharable_resource)
    end

    it 'can destroy shared resource' do
      expect(ability).to be_able_to(:destroy, sharable_resource)
    end
  end

  context 'when logged in as user with shared read access' do
    let(:ability) { EzOnRails::Ability.new(christoph) }

    it 'can show shared resource' do
      expect(ability).to be_able_to(:show, sharable_resource)
    end

    it 'can not update shared resource' do
      expect(ability).not_to be_able_to(:update, sharable_resource)
    end

    it 'can not destroy shared resource' do
      expect(ability).not_to be_able_to(:destroy, sharable_resource)
    end
  end

  context 'when logged in as user with shared write access' do
    let(:ability) { EzOnRails::Ability.new(john) }

    it 'can not show shared resource' do
      expect(ability).not_to be_able_to(:show, sharable_resource)
    end

    it 'can update shared resource' do
      expect(ability).to be_able_to(:update, sharable_resource)
    end

    it 'can not destroy shared resource' do
      expect(ability).not_to be_able_to(:destroy, sharable_resource)
    end
  end

  context 'when logged in as user with shared destroy access' do
    let(:ability) { EzOnRails::Ability.new(florian) }

    it 'can not show shared resource' do
      expect(ability).not_to be_able_to(:show, sharable_resource)
    end

    it 'can not update shared resource' do
      expect(ability).not_to be_able_to(:update, sharable_resource)
    end

    it 'can destroy shared resource' do
      expect(ability).to be_able_to(:destroy, sharable_resource)
    end
  end

  context 'when logged in as admin' do
    let(:ability) { EzOnRails::Ability.new(admin) }

    it 'can show shared resource' do
      expect(ability).to be_able_to(:show, sharable_resource)
    end

    it 'can update shared resource' do
      expect(ability).to be_able_to(:update, sharable_resource)
    end

    it 'can destroy shared resource' do
      expect(ability).to be_able_to(:destroy, sharable_resource)
    end
  end
end
