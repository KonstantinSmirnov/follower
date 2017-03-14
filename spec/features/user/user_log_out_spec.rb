require 'rails_helper'

feature 'USER LOG OUT' do
  scenario 'logs out' do
    user = FactoryGirl.create(:user)
    user.activate!

    user.password = 'password'
    user.password_confirmation = 'password'
    user.save

    log_in_with(user.email,  'password')

    click_link 'Log Out'

    expect(current_path).to eq(login_path)
    expect(page).to have_text('Logged out')
  end
end
