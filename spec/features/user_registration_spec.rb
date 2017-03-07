require 'rails_helper'

feature 'USERS REGISTRATION' do
  scenario 'responds to register path'

  feature 'form validations' do
    scenario 'fails without an email'
    scenario 'fails without a password'
    scenario 'fails withotu a password confirmation'
    scenario 'fails if confirmation password does not matches the password'
  end

  feature 'user exists' do
    scenario 'fails if the email already exists'
    scenario 'fails if the email already exists even if account was not activated'
  end

  feature 'registration' do
    scenario 'registers with valid data'
    scenario 'sends an email with a confirmation link'
    scenario 'activates the account if user follows  valid activation link'
    scenario 'a please login message will be displayed for users followed the activatio link'
    scenario 'a please login message will be displayed if activation token is unknown'
    scenario 'sends a welcome email after account activation'
  end


end
