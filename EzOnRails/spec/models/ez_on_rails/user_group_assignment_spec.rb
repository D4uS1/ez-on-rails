# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EzOnRails::UserGroupAssignment do
  let(:user) do
    create(:user)
  end
  let(:testgroup) do
    create(:testgroup)
  end
  let(:user_group_assignment_attributes) do
    {
      group_id: testgroup.id,
      user_id: user.id
    }
  end
  let(:resource) { create(:sharable_resource) }

  context 'when validating' do
    it 'creates valid record' do
      expect(described_class.create(user_group_assignment_attributes)).to be_valid
    end

    it 'user required' do
      expect(described_class.create(
               user_group_assignment_attributes.merge(user_id: nil)
             )).to be_invalid
    end

    it 'group required' do
      expect(described_class.create(
               user_group_assignment_attributes.merge(group_id: nil)
             )).to be_invalid
    end

    it 'does not create if group was already assigned to the user without resource' do
      described_class.create(user_group_assignment_attributes)

      expect(described_class.create(user_group_assignment_attributes)).to be_invalid
    end

    it 'does not create if group was already assigned to the user with resource' do
      testgroup.update(resource_group: true)

      described_class.create(user_group_assignment_attributes.merge({
                                                                      resource_type: resource.class.to_s,
                                                                      resource_id: resource.id
                                                                    }))

      expect(described_class.create(user_group_assignment_attributes.merge({
                                                                             resource_type: resource.class.to_s,
                                                                             resource_id: resource.id
                                                                           }))).to be_invalid
    end

    it 'creates if user was already assigned to the group with other resource' do
      testgroup.update(resource_group: true)
      resource_two = create(:sharable_resource)

      described_class.create(user_group_assignment_attributes.merge({
                                                                      resource_type: resource.class.to_s,
                                                                      resource_id: resource.id
                                                                    }))

      expect(described_class.create(user_group_assignment_attributes.merge({
                                                                             resource_type: resource_two.class.to_s,
                                                                             resource_id: resource_two.id
                                                                           }))).to be_valid
    end

    it 'does not create if resource is assigned but group is not flagged as resource group' do
      testgroup.update(resource_group: false)

      expect(described_class.create(user_group_assignment_attributes.merge({ resource: resource }))).to be_invalid
    end

    it 'creates if resource is assigned and group is flagged as resource group' do
      testgroup.update(resource_group: true)

      expect(described_class.create(user_group_assignment_attributes.merge({ resource: resource }))).to be_valid
    end
  end

  context 'when using hooks' do
    let(:andrew) do
      create(:andrew)
    end
    let(:john) do
      create(:john)
    end

    it 'can not update member assignment' do
      member_assignment = described_class.find_by(user: andrew, group: EzOnRails::Group.member_group)

      expect(member_assignment.update(user: john)).to be(false)
    end

    it 'can not update super administration assignment' do
      admin_assignment = described_class.super_admin_assignment

      expect(admin_assignment.update(user: andrew)).to be(false)
    end

    it 'can not destroy member assignment' do
      member_assignment = described_class.find_by(user: andrew, group: EzOnRails::Group.member_group)

      expect(member_assignment.destroy).to be(false)
    end

    it 'can not destroy super administration assignment' do
      admin_assignment = described_class.super_admin_assignment

      expect(admin_assignment.destroy).to be(false)
    end
  end
end
