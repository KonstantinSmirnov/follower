require 'rails_helper'

feature 'WIDGET WORKFLOW STEP 8' do
  let!(:user) { FactoryGirl.create(:user, password: 'password', password_confirmation: 'password') }
  let!(:webpage) { FactoryGirl.create(:webpage_with_script, user: user) }

  before(:each) do
    user.activate!
    log_in_with(user.email, 'password')

    visit test_widget_with_script_path(follower_widget_id: webpage.id, follower_widget_token: webpage.widget_token)
    sleep 1
    # Starts automatic setup
    click_button 'follower_widget__automatic_setup'
    # Confirms STEP 1
    page.find('#follower_widget__modal_confirm').click
    # Skip STEP 2 select image
    page.find('#follower_widget__modal_decline').click
    # Skip STEP 3
    page.find('#follower_widget__modal_decline').click
    # Skip STEP 4
    page.find('#follower_widget__modal_decline').click
    # Skip STEP 5
    page.find('#follower_widget__modal_decline').click
    # Skip STEP 6
    page.find('#follower_widget__modal_decline').click
    # Skip STEP 7
    page.find('#follower_widget__modal_decline').click
    # Skip STEP 8
    page.find('#follower_widget__modal_decline').click
  end

  scenario 'has correct modal window with final message', js: true do
    expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 9')
    expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Finish')
    expect(page).not_to have_selector('#follower_widget__modal_decline')
  end

  scenario 'clicking on confirm button finishes the process', js: true do
    page.find('#follower_widget__modal_confirm').click

    expect(page).not_to have_selector('#follower_widget__modal')
    expect(page).to have_selector('#follower_widget__collapse_button', text: '>')
    expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'START AUTOMATIC SETUP')
  end

  scenario 'ask user to close webpage with widget if finished setup'
end
