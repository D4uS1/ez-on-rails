# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EzOnRails::Group do
  let(:group_attributes) do
    {
      name: 'Testgroup',
      user: nil
    }
  end

  context 'when validating' do
    it 'creates valid record' do
      expect(described_class.create(group_attributes)).to be_valid
    end

    it 'requires name' do
      expect(described_class.create(group_attributes.merge(name: nil))).to be_invalid
    end

    it 'has unique name' do
      described_class.create(group_attributes)

      expect(described_class.create(group_attributes)).to be_invalid
    end

    it 'name must match user_group_name of user if user exists' do
      andrew = create(:andrew)

      expect(andrew.user_group.update(name: 'John')).to be(false)
    end

    it 'does not unassign user of usergroup' do
      andrew = create(:andrew)

      expect(andrew.user_group.update(user: nil)).to be(false)
    end

    it 'does not create if resource_read is set but resource_group is not set' do
      expect(described_class.create(group_attributes.merge({ resource_group: false,
                                                             resource_read: true }))).to be_invalid
    end

    it 'does not create if resource_write is set but resource_group is not set' do
      expect(described_class.create(group_attributes.merge({ resource_group: false,
                                                             resource_write: true }))).to be_invalid
    end

    it 'does not create if resource_destroy is set but resource_group is not set' do
      expect(described_class.create(group_attributes.merge({ resource_group: false,
                                                             resource_destroy: true }))).to be_invalid
    end

    it 'creates if resource access flag is set and resource_group is set' do
      expect(described_class.create(group_attributes.merge({ resource_group: true, resource_read: true }))).to be_valid
    end
  end

  context 'when using hooks' do
    it 'can not update member group' do
      expect(described_class.member_group.update(name: group_attributes[:name])).to be(false)
    end

    it 'can not update admin group' do
      expect(described_class.super_admin_group.update(name: group_attributes[:name])).to be(false)
    end

    it 'can not destroy member group' do
      expect(described_class.member_group.destroy).to be(false)
    end

    it 'can not destroy admin group' do
      expect(described_class.super_admin_group.destroy).to be(false)
    end

    it 'can not destroy user group' do
      andrew = create(:andrew)

      expect(andrew.user_group.destroy).to be(false)
    end
  end
end
