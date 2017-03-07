require 'rails_helper'

feature 'USERS REGISTRATION' do

  feature 'form validations' do
    scenario 'fails without an email' do
      visit root_path

      click_link
    end

    scenario 'fails if email format is invalid'
  end

  feature 'user exists' do
    scenario 'fails if the email already exists'
    scenario 'fails if the email already exists even if account was not activated'
  end

  feature 'registration' do
    scenario 'registers with valid email'
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
