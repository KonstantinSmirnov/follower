require 'rails_helper'

feature 'USERS REGISTRATION' do

  before(:each) do
    visit root_path
  end

  feature 'form validations' do
    scenario 'fails without an email', js: true do
      click_button 'registration_button'

      expect(page).to have_selector('#registration_errors', text: "Email can't be blank")
    end

    scenario 'fails if email format is invalid', js: true do
      fill_in 'registration_email', with: 'invalid-email@@test.com'
      click_button 'registration_button'

      expect(page).to have_selector('#registration_errors', text: 'Email is invalid')
    end
  end

  feature 'user exists' do
    scenario 'fails if the email already exists', js: true do
      FactoryGirl.create(:user, email: 'test@test.com')
      fill_in 'registration_email', with: 'test@test.com'
      click_button 'registration_button'

      expect(page).to have_selector('#registration_errors', text: 'Email has already been taken')
    end

    scenario 'fails if the email already exists even if account was not activated'
  end

  feature 'registration' do
    scenario 'registers with a valid email', js: true do
      fill_in 'registration_email', with: 'valid@email.com'
      click_button 'registration_button'

      expect(page).to have_selector('#modal .modal-title', text: 'Successful registration')
    end

    scenario 'sends an email with a confirmation link'
    scenario 'asks user to select password if user follows activation link'
    scenario 'activates the account after confirmed selected password'
    feature 'select password validation' do
      scenario 'fails without password'
      scenario 'fails without password confirmation'
      scenario 'fails if password and password confirmation do not match'
    end
    scenario 'user redirects to home page after activation'
    scenario 'a please login message will be displayed if activation token is unknown'
    scenario 'sends a welcome email after account activation'
  end


end
