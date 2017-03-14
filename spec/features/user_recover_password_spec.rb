require 'rails_helper'

feature 'RECOVER PASSWORD' do
  scenario 'email is not sent if email is not provided' do
    visit new_password_reset_path

    expect {
      click_button 'Reset my password'
    }.to change {
      ActionMailer::Base.deliveries.size
    }.by(0)

    expect(page).to have_text('Instructions have been sent to your email')
  end

  scenario 'email is not sent if email has invalid format' do
    visit new_password_reset_path

    fill_in 'user_email', with: 'invalid_email'

    expect {
      click_button 'Reset my password'
    }.to change {
      ActionMailer::Base.deliveries.size
    }.by(0)

    expect(page).to have_text('Instructions have been sent to your email')
  end

  scenario 'email is not sent if there is no users with such email' do
    visit new_password_reset_path

    fill_in 'user_email', with: 'unexistent@email.com'

    expect {
      click_button 'Reset my password'
    }.to change {
      ActionMailer::Base.deliveries.size
    }.by(0)

    expect(page).to have_text('Instructions have been sent to your email')
  end

  # skip this test - can check which users are registered
  scenario 'email is not sent if is unknown'

  feature 'EMAIL EXISTS IN DB' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      visit new_password_reset_path
      fill_in 'user_email', with: @user.email
    end

    scenario 'sends an email to the user with a link to change the password' do
      expect {
        click_button 'Reset my password'
      }.to change {
        ActionMailer::Base.deliveries.size
      }.by(1)

      email = ActionMailer::Base.deliveries.last

      expect(email.subject).to eq('Reset your password')
      expect(email.to[0]).to eq(@user.email)
      @user.reload
      expect(email.body.to_s).to include(edit_password_reset_path(@user.reset_password_token))
    end

    feature 'FORM' do
      scenario 'is displayed if followed the valid recover link' do
        click_button 'Reset my password'

        @user.reload
        visit edit_password_reset_path(@user.reset_password_token)

        expect(current_path).to eq(edit_password_reset_path(@user.reset_password_token))
        expect(page).to have_selector('h1', text: 'Choose a new password')
      end

      scenario 'fails if new password is not provided (empty field)' do
        click_button 'Reset my password'

        @user.reload
        visit edit_password_reset_path(@user.reset_password_token)

        click_button 'Update'

        expect(page).to have_text('Your new password is invalid')
      end

      scenario 'fails if password confirmation is not provided' do
        click_button 'Reset my password'

        @user.reload
        visit edit_password_reset_path(@user.reset_password_token)

        fill_in 'user_password', with: 'password'
        click_button 'Update'

        expect(page).to have_text('Your new password is invalid')
        expect(page).to have_selector('.user_password_confirmation span.help-block', text: "doesn't match Password")
      end

      scenario 'fails if new password does not match the password confirmation' do
        click_button 'Reset my password'

        @user.reload
        visit edit_password_reset_path(@user.reset_password_token)

        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'anotherpassword'
        click_button 'Update'

        expect(page).to have_text('Your new password is invalid')
        expect(page).to have_selector('.user_password_confirmation span.help-block', text: "doesn't match Password")
      end

      scenario 'fails if new password is too short' do
        click_button 'Reset my password'

        @user.reload
        visit edit_password_reset_path(@user.reset_password_token)

        fill_in 'user_password', with: '123'
        fill_in 'user_password_confirmation', with: '123'
        click_button 'Update'

        expect(page).to have_text('Your new password is invalid')
        expect(page).to have_selector('.user_password span.help-block', text: "is too short (minimum is 6 characters)")
      end

      scenario 'changes the password' do
        click_button 'Reset my password'

        @user.reload
        crypted_password = @user.crypted_password
        visit edit_password_reset_path(@user.reset_password_token)

        fill_in 'user_password', with: '123123'
        fill_in 'user_password_confirmation', with: '123123'
        click_button 'Update'
        @user.reload

        expect(page).to have_text('Password was successfully updated')
        expect(@user.crypted_password).not_to eq(crypted_password)
      end
    end

    scenario 'can not reset a password if follows used reset password link' do
      click_button 'Reset my password'

      @user.reload
      password_reset_path = edit_password_reset_path(@user.reset_password_token)
      visit password_reset_path

      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button 'Update'

      visit password_reset_path

      expect(page).to have_text('Invalid token')
      expect(current_path).to eq(login_path)
    end

    scenario 'can not reset a password if follows invalid reset link' do
      visit edit_password_reset_path('invalid_token')

      expect(current_path).to eq(login_path)
    end

    scenario 'can not reset a password if reset token is expired'
  end
end
