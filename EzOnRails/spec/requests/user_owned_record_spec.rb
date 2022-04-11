# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

# Spec for testing the access system for ownership infos.
# The users john and andrew has owned resources.
# This spec will test whether the users are able to access their own resources, but not those of the other one.
# This spec also tests whether some not logged in user is not be able to access any of
# this resources.
# This spec also tests whether the admin can access all resources.
describe 'User owned record access', type: :request do
  let(:andrew) { create(:andrew) }
  let(:john) { create(:john) }
  let(:admin) { User.super_admin }
  let(:andrews_record) do
    create(:user_owned_record, owner: andrew)
  end
  let(:anonymous_record) do
    create(:user_owned_record, owner: nil)
  end

  before do
    create(:eor_ownership_info, resource: 'UserOwnedRecord')
  end

  context 'when not logged in' do
    let(:ability) { EzOnRails::Ability.new(nil) }

    it 'can not show users record' do
      expect(ability).not_to be_able_to(:show, andrews_record)
    end

    it 'can not update users record' do
      expect(ability).not_to be_able_to(:update, andrews_record)
    end

    it 'can not destroy users record' do
      expect(ability).not_to be_able_to(:destroy, andrews_record)
    end

    it 'can show anonymous record' do
      expect(ability).to be_able_to(:show, anonymous_record)
    end

    it 'can update anonymous record' do
      expect(ability).to be_able_to(:update, anonymous_record)
    end

    it 'can destroy anonymous record' do
      expect(ability).to be_able_to(:destroy, anonymous_record)
    end
  end

  context 'when logged in as owner of the record' do
    let(:ability) { EzOnRails::Ability.new(andrew) }

    it 'can show users record' do
      expect(ability).to be_able_to(:show, andrews_record)
    end

    it 'can update users record' do
      expect(ability).to be_able_to(:update, andrews_record)
    end

    it 'can destroy users record' do
      expect(ability).to be_able_to(:destroy, andrews_record)
    end

    it 'can show anonymous record' do
      expect(ability).to be_able_to(:show, anonymous_record)
    end

    it 'can update anonymous record' do
      expect(ability).to be_able_to(:update, anonymous_record)
    end

    it 'can destroy anonymous record' do
      expect(ability).to be_able_to(:destroy, anonymous_record)
    end
  end

  context 'when logged in as not owner of the record' do
    let(:ability) { EzOnRails::Ability.new(john) }

    it 'can not show users record' do
      expect(ability).not_to be_able_to(:show, andrews_record)
    end

    it 'can not update users record' do
      expect(ability).not_to be_able_to(:update, andrews_record)
    end

    it 'can not destroy users record' do
      expect(ability).not_to be_able_to(:destroy, andrews_record)
    end

    it 'can show anonymous record' do
      expect(ability).to be_able_to(:show, anonymous_record)
    end

    it 'can update anonymous record' do
      expect(ability).to be_able_to(:update, anonymous_record)
    end

    it 'can destroy anonymous record' do
      expect(ability).to be_able_to(:destroy, anonymous_record)
    end
  end

  context 'when logged in as admin' do
    let(:ability) { EzOnRails::Ability.new(admin) }

    it 'can show users record' do
      expect(ability).to be_able_to(:show, andrews_record)
    end

    it 'can update users record' do
      expect(ability).to be_able_to(:update, andrews_record)
    end

    it 'can destroy users record' do
      expect(ability).to be_able_to(:destroy, andrews_record)
    end

    it 'can show anonymous record' do
      expect(ability).to be_able_to(:show, anonymous_record)
    end

    it 'can update anonymous record' do
      expect(ability).to be_able_to(:update, anonymous_record)
    end

    it 'can destroy anonymous record' do
      expect(ability).to be_able_to(:destroy, anonymous_record)
    end
  end
end
