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
  end

  feature 'registration' do
    scenario 'registers with a valid email', js: true do
      fill_in 'registration_email', with: 'valid@email.com'
      click_button 'registration_button'
      sleep 1
      expect(page).to have_selector('#modal .modal-title', text: 'Successful registration')
    end

    scenario 'sends an email with a confirmation link', js: true do
      expect {
        fill_in 'registration_email', with: 'valid_email@mail.com'
        click_button 'registration_button'
        sleep 1
      }.to change {
        ActionMailer::Base.deliveries.size
      }.by(1)

      user = User.find_by_email('valid_email@mail.com')
      confirmation_email = ActionMailer::Base.deliveries.last

      expect(confirmation_email.subject).to eq('Account confirmation')
      expect(confirmation_email.to[0]).to eq('valid_email@mail.com')
      expect(confirmation_email.body).to include('Thank you for registering')
      expect(confirmation_email.body).to include(activate_user_path(user.activation_token))
    end

    scenario 'activates the account if user follows activation link', js: true do
      user = FactoryGirl.create(:user)

      visit activate_user_path(user.activation_token)

      expect(page).to have_text('User was successfully activated')
    end

    scenario 'asks user to select new password after activation', js: true do
      user = FactoryGirl.create(:user)

      visit activate_user_path(user.activation_token)
      user.reload

      expect(current_path).to eq(edit_password_reset_path(user.reset_password_token))
    end

    scenario 'a please login message will be displayed if an active user follows activation link' do
      user = FactoryGirl.create(:user)
      url = activate_user_path(user.activation_token)
      user.activate!

      visit url

      expect(current_path).to eq(login_path)
      expect(page).to have_text('Activation token is invalid')
    end

    scenario 'a please login message will be displayed if activation token is unknown' do
      visit activate_user_path('invalid_token')

      expect(current_path).to eq(login_path)
      expect(page).to have_text('Activation token is invalid')
    end

    scenario 'sends a welcome email after account activation' do
      user = FactoryGirl.create(:user)
      expect {
        visit activate_user_path(user.activation_token)
      }.to change {
        ActionMailer::Base.deliveries.size
      }.by(1)

      email = ActionMailer::Base.deliveries.last

      expect(email.subject).to eq('Your account is now activated')
      expect(email.body).to include('Your Follower account has been activated')
    end
  end


end
