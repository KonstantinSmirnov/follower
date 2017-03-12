require 'rails_helper'

feature 'USER LOG IN' do
  scenario 'has login page' do
    visit login_path

    expect(current_path).to eq(login_path)
    expect(page).to have_selector('h1', text: "Log in")
  end

  scenario 'fails without email' do
    visit login_path

    fill_in 'user_password', with: '123123'
    click_button 'Log In'

    expect(page).to have_text('Email or password is invalid')
  end

  scenario 'fails with an invalid email' do
    visit login_path

    fill_in 'user_email', with: 'invalid-email'
    fill_in 'user_password', with: 'password'
    click_button 'Log In'

    expect(page).to have_text('Email or password is invalid')
  end

  scenario 'fails without a password' do
    visit login_path

    fill_in 'user_email', with: 'test@test.com'
    click_button 'Log In'

    expect(page).to have_text('Email or password is invalid')
  end

  scenario 'logs in with with a valid user and password' do
    user = FactoryGirl.create(:user)
    user.activate!
    user.password = 'password'
    user.password_confirmation = 'password'
    user.save

    visit login_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_button 'Log In'

    expect(page).to have_text('Login successful')
    expect(current_path).to eq(dashboard_path)
  end
end
