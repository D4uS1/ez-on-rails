# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) { attributes_for(:andrew).merge({ password: 'testpassword' }) }

  context 'when validating' do
    it 'creates valid record' do
      expect(described_class.create(valid_attributes)).to be_truthy
    end

    it 'does not create a user without email' do
      expect(described_class.create(valid_attributes.merge(email: nil))).not_to be_valid
    end

    it 'does not create a user not accepting the privacy policy' do
      expect(described_class.create(valid_attributes.merge(privacy_policy_accepted: false))).not_to be_valid
    end

    it 'email is unique' do
      described_class.create(valid_attributes)

      expect(described_class.create(valid_attributes.merge(username: 'Other user'))).not_to be_valid
    end

    it 'does not create user with existing user_group_name' do
      create(:eor_group, name: 'testuser@test.com')

      expect(described_class.create(valid_attributes.merge({ email: 'testuser@test.com' }))).not_to be_valid
    end

    it 'does not update user with existing user_group_name' do
      create(:eor_group, name: 'testuser_updated@something.com')
      user = described_class.create(valid_attributes)

      expect(user.update(email: 'testuser_updated@something.com')).to be(false)
    end
  end

  context 'when using hooks' do
    it 'can not destroy admin' do
      expect(described_class.super_admin.destroy).to be(false)
    end

    it 'can not update admin name' do
      expect(described_class.super_admin.update(username: 'Testuser')).to be(false)
    end

    it 'creates an user group after creating user' do
      user = described_class.create(valid_attributes)

      expect(EzOnRails::Group.find_by(name: valid_attributes[:email])).not_to be_nil
      expect(user.user_group.name).to eq(user.email)
    end

    it 'renames user group if username changes' do
      user = described_class.create(valid_attributes)

      user.update(username: 'UpdatedName')
      expect(user.user_group.name).to eq(user.email)
    end

    it 'removes user group on user deletion' do
      user = described_class.create!(valid_attributes)
      user.destroy!

      expect(EzOnRails::Group.find_by(name: valid_attributes[:username])).to be_nil
    end

    it 'creates a default oauth provider if no provided' do
      user = described_class.create!(valid_attributes)

      expect(user.provider).to eq('email')
      expect(user.uid).to eq(user.email)
    end

    context 'when cascade destroy on owned resources' do
      let(:andrew) { create(:andrew) }
      let(:john) { create(:john) }
      let(:andrews_record) { create(:eor_group, name: 'Andrews record', owner: andrew) }
      let(:johns_record) { create(:eor_group, name: 'Johns record', owner: john) }
      let(:anonymous_record) { create(:eor_group, name: 'Anonymous record', owner: nil) }
      let(:ownership_info) { create(:eor_ownership_info, resource: 'EzOnRails::Group') }

      before do
        ownership_info
        andrews_record
        johns_record
        anonymous_record
      end

      it 'nullifies owner reference if ownership_infos on_owner_destroy field is not set' do
        andrew.destroy

        andrews_record.reload
        johns_record.reload
        anonymous_record.reload

        expect(andrews_record.owner).to be_nil
        expect(johns_record.owner_id).to eq(john.id)
        expect(anonymous_record.owner).to be_nil
      end

      it 'nullifies owner reference if ownership_info is configured to nullify' do
        ownership_info.update(on_owner_destroy: 'resource_nullify')

        andrew.destroy

        andrews_record.reload
        johns_record.reload
        anonymous_record.reload

        expect(andrews_record.owner).to be_nil
        expect(johns_record.owner_id).to eq(john.id)
        expect(anonymous_record.owner).to be_nil
      end

      it 'destroys owner reference if ownership_info is configured to destroy' do
        ownership_info.update(on_owner_destroy: 'resource_destroy')

        andrew.destroy

        johns_record.reload
        anonymous_record.reload

        expect(EzOnRails::Group.find_by(id: andrews_record.id)).to be_nil
        expect(johns_record.owner_id).to eq(john.id)
        expect(anonymous_record.owner).to be_nil
      end

      it 'deletes owner reference if ownership_info is configured to delete' do
        ownership_info.update(on_owner_destroy: 'resource_delete')

        andrew.destroy

        johns_record.reload
        anonymous_record.reload

        expect(EzOnRails::Group.find_by(id: andrews_record.id)).to be_nil
        expect(johns_record.owner_id).to eq(john.id)
        expect(anonymous_record.owner).to be_nil
      end
    end
  end

  context 'when testing other methods' do
    it 'user_group_name is the email' do
      user = described_class.create(valid_attributes.merge({ email: 'test1@mail.com' }))
      expect(user.user_group_name).to eq('test1@mail.com')

      user_two = described_class.create(valid_attributes.merge({ email: 'test.dat@othermail.com' }))
      expect(user_two.user_group_name).to eq('test.dat@othermail.com')
    end

    context 'when using in_group?' do
      let(:andrew) { create(:andrew) }
      let(:group) { create(:eor_group) }
      let(:resource) { create(:sharable_resource) }

      it 'returns false if user is not assigned to the group' do
        expect(andrew.in_group?(group.name)).to be(false)
      end

      context 'when user assigned to group' do
        before do
          andrew.groups << group
        end

        it 'returns true if the group is no resource group' do
          expect(andrew.in_group?(group.name)).to be(true)
        end

        context 'when group is resource_group' do
          before do
            group.update(resource_group: true)
          end

          it 'returns true if user is assigned to the resource with the group' do
            andrew.user_group_assignments.find_by(group: group).update(resource: resource)

            expect(andrew.in_group?(group.name, resource)).to be(true)
          end

          it 'returns true if user is not assigned to the resource with the group and any was passed' do
            expect(andrew.in_group?(group.name, :any)).to be(true)
          end

          it 'returns true if user is assigned to the resource with the group and any was passed' do
            andrew.user_group_assignments.find_by(group: group).update(resource: resource)

            expect(andrew.in_group?(group.name, :any)).to be(true)
          end

          it 'returns false if nil was passed as resource' do
            andrew.user_group_assignments.find_by(group: group).update(resource: resource)

            expect(andrew.in_group?(group.name)).to be(false)
          end

          it 'returns false if the user is not assigned to the resource with the group' do
            expect(andrew.in_group?(group.name, resource)).to be(false)
          end
        end
      end
    end
  end
end
