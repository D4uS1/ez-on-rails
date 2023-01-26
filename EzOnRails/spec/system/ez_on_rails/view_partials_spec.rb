# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the partials view behavior and some of those functionalities.
# The following partials are not tested due to the fact that it is not used by the lib itselfs or it was not nessecary:
# * nested_model_form
# * table
# * header
# * modals/modal
# * modals/modal_form
# * modals/_ok
# * modals/_yes_no
# * modals/preview
RSpec.describe 'View partials' do
  # users
  let(:admin) { User.super_admin }

  # for edit action test
  let(:group_update) do
    create(:eor_group,
           name: 'Testgroup')
  end
  let(:group_update_assignment) do
    create(:eor_user_group_assignment,
           user: admin,
           group: group_update)
  end

  context 'when logged in as admin' do
    before do
      system_log_in User.super_admin.email, '1replace_me3_after3_install7'
    end

    it 'can see groups index / enhanced_table' do
      visit '/ez_on_rails/admin/user_management/groups'

      # Search form is visible
      expect(page).to have_text(t(:'ez_on_rails.search'))

      # table headers are visible
      expect(page).to have_text(EzOnRails::Group.human_attribute_name(:name))
      expect(page).to have_text(EzOnRails::Group.human_attribute_name(:users))
      expect(page).to have_css('.fa-eye')
      expect(page).to have_css('.fa-edit')
      expect(page).to have_css('.fa-trash')

      # table content is visible
      expect(page).to have_text('Admin')
      expect(page).to have_text('Member')
      expect(page).to have_text('Administrator')
    end

    it 'search for group using search_form' do
      visit '/ez_on_rails/admin/user_management/groups'

      find('details > summary').click
      fill_in 'q_name_cont', with: 'Member'
      click_on t(:'ez_on_rails.search')

      expect(page).to have_text('Member')
      expect(page).not_to have_text('Admin', exact: true)
    end

    it 'can update group by using model_form in edit action' do
      visit "/ez_on_rails/admin/user_management/groups/#{group_update_assignment.group.id}/edit"

      # labels are visible
      expect(page).to have_css('label', text: EzOnRails::Group.human_attribute_name(:name))
      expect(page).to have_css('label', text: EzOnRails::Group.human_attribute_name(:users))

      # values are visible
      expect(find_field('ez_on_rails_group_name').value).to eql(group_update.name)
      expect(page).to have_css('li', text: admin.email)

      # change value
      fill_in 'ez_on_rails_group_name', with: 'NewGroupName'
      click_on t(:'ez_on_rails.save')

      # see show page with new value
      expect(page).to have_current_path(
        "/#{I18n.locale}/ez_on_rails/admin/user_management/groups/#{group_update.id}"
      )
      expect(page).to have_text 'NewGroupName'
    end

    it 'can see group show' do
      visit "/ez_on_rails/admin/user_management/groups/#{EzOnRails::Group.super_admin_group.id}"

      # labels are visible
      expect(page).to have_text(EzOnRails::Group.human_attribute_name(:name))
      expect(page).to have_text(EzOnRails::Group.human_attribute_name(:users))

      # values are visible
      expect(page).to have_text('Admin')
      expect(page).to have_text('Administrator')
    end

    it 'can see user_management dashboard' do
      visit '/ez_on_rails/admin/user_management/dashboard/'

      # categories
      expect(page).to have_text(t(:'ez_on_rails.users_and_groups'))
      expect(page).to have_text(t(:'ez_on_rails.permissions'))

      # tile titles
      expect(page).to have_text(User.model_name.human(count: 2))
      expect(page).to have_text(EzOnRails::Group.model_name.human(count: 2))
      expect(page).to have_text(EzOnRails::UserGroupAssignment.model_name.human(count: 2))
      expect(page).to have_text(EzOnRails::GroupAccess.model_name.human(count: 2))
      expect(page).to have_text(EzOnRails::OwnershipInfo.model_name.human(count: 2))
    end

    it 'submits contact form using form' do
      visit 'contact_form/'

      # see labels
      expect(page).to have_text(ContactForm.human_attribute_name(:name))
      expect(page).to have_text(ContactForm.human_attribute_name(:email))
      expect(page).to have_text(ContactForm.human_attribute_name(:subject))
      expect(page).to have_text(ContactForm.human_attribute_name(:message))

      # fill fields and submit
      fill_in 'contact_form_name', with: 'Andrew'
      fill_in 'contact_form_email', with: 'andrew@test.com'
      fill_in 'contact_form_subject', with: 'Testing the form partial!'
      fill_in 'contact_form_message', with: 'This is a test of the form partial!'
      check 'contact_form_privacy_policy_accepted'
      click_on t(:'ez_on_rails.submit')

      expect(page).to have_current_path("/#{I18n.locale}/contact_form/submit")
      expect(page).to have_text(t(:contact_form_submit_message))
    end

    it 'can not submit contact form without accepting privacy policy' do
      visit 'contact_form/'

      # see labels
      expect(page).to have_text(ContactForm.human_attribute_name(:name))
      expect(page).to have_text(ContactForm.human_attribute_name(:email))
      expect(page).to have_text(ContactForm.human_attribute_name(:subject))
      expect(page).to have_text(ContactForm.human_attribute_name(:message))

      # fill fields and submit
      fill_in 'contact_form_name', with: 'Andrew'
      fill_in 'contact_form_email', with: 'andrew@test.com'
      fill_in 'contact_form_subject', with: 'Testing the form partial!'
      fill_in 'contact_form_message', with: 'This is a test of the form partial!'
      click_on t(:'ez_on_rails.submit')

      expect(page).to have_text(
        t(:'activemodel.errors.models.contact_form.attributes.privacy_policy_accepted.accepted')
      )
    end

    it 'can navigate using breadcrumbs' do
      visit "/ez_on_rails/admin/user_management/groups/#{EzOnRails::Group.super_admin_group.id}"

      # sees all breadcrumbs
      expect(page).to have_text(t(:welcome_title))
      expect(page).to have_text(t(:'ez_on_rails.administration'))
      expect(page).to have_text(t(:'ez_on_rails.user_management'))
      expect(page).to have_text(EzOnRails::Group.model_name.human(count: 2))

      # navigate
      click_on t(:'ez_on_rails.user_management')
      expect(page).to have_current_path("/#{I18n.locale}/ez_on_rails/admin/user_management/dashboard")
    end

    it 'can navigate to imprint using footer' do
      visit '/'

      # see foter content
      expect(page).to have_text(t(:imprint))
      expect(page).to have_text(t(:privacy_policy))
      expect(page).to have_text(t(:contact_form))

      # navigate to imprint
      click_on t(:imprint)
      expect(page).to have_current_path("/#{I18n.locale}/imprint")
    end

    it 'can navigate to privacy_policy using footer' do
      visit '/'

      # navigate to imprint
      click_on t(:privacy_policy)
      expect(page).to have_current_path("/#{I18n.locale}/privacy_policy")
    end

    it 'can navigate using navigation' do
      visit '/'

      click_on t(:'ez_on_rails.administration')
      click_on t(:'ez_on_rails.user_management')
      expect(page).to have_current_path("/#{I18n.locale}/ez_on_rails/admin/user_management/dashboard")
    end

    it 'can see title' do
      visit '/'

      expect(page).to have_text(t(:welcome_title))
      expect(page).to have_text(t(:welcome_subtitle))
    end

    it 'can switch locale using locale_switch' do
      visit '/en/welcome/'
      find('.flag-icon-de').click

      expect(page).to have_current_path('/de/welcome')
      expect(page).to have_text('Willkommen')
    end

    it 'can logout using userbar' do
      visit '/'

      find_by_id('dropdown_userbar_user').click
      find('a[name=logout]').click
      expect(page).to have_text(t(:'devise.sessions.signed_out'))
      expect(page).not_to have_text(admin.username)
    end
  end
end
