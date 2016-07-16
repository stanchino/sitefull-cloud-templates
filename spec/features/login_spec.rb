# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  let(:password) { 'test1234' }

  describe 'existing users' do
    let(:user) { FactoryGirl.create(:user, password: password, password_confirmation: password) }

    scenario 'should be able to login' do
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: password
      click_on 'Log in'
      expect(current_path).to eq user_root_path
      expect(page).to have_link 'Gallery'
      expect(page).to have_link 'Deployments'
    end
  end

  describe 'registration' do
    let(:user) { FactoryGirl.build(:user) }

    background { clear_emails }

    scenario 'should be able to sign_up' do
      visit new_user_registration_path
      click_on 'Sign up'
      expect(page).to have_text('can\'t be blank')
    end

    scenario 'should be able to sign_up' do
      visit new_user_registration_path
      fill_in 'First name', with: user.first_name
      fill_in 'Last name', with: user.last_name
      fill_in 'Email', with: user.email
      fill_in 'Password', with: password, match: :prefer_exact
      fill_in 'Password confirmation', with: password, match: :prefer_exact
      click_on 'Sign up'
      open_email user.email
      current_email.click_link 'Confirm my account'
      expect(current_path).to eq new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: password
      click_on 'Log in'
      expect(page).to have_link 'Gallery'
      expect(page).to have_link 'Deployments'
      expect(page).to have_link 'Sign Out'
      expect(page).to have_text 'Signed in successfully.'
    end
  end
end
