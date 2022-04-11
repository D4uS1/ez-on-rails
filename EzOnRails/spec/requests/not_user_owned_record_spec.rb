# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

# Spec for testing the access system for default resources, that are no ownership infos but has the owner field.
# Everyone should be able to do anything with those resources, independent of the creator of the resource.
describe 'Not user owned record access', type: :request do
  let(:andrew) { create(:andrew) }
  let(:john) { create(:john) }
  let(:admin) { User.super_admin }
  let(:andrews_record) do
    create(:not_user_owned_record, owner: andrew)
  end
  let(:anonymous_record) do
    create(:not_user_owned_record, owner: nil)
  end

  context 'when not logged in' do
    let(:ability) { EzOnRails::Ability.new(nil) }

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
