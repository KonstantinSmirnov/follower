require 'rails_helper'

feature 'WIDGET WORKFLOW STEP 1' do
  let!(:user) { FactoryGirl.create(:user, password: 'password', password_confirmation: 'password') }
  let!(:webpage) { FactoryGirl.create(:webpage_with_script, user: user) }

  before(:each) do
    user.activate!
    log_in_with(user.email, 'password')

    visit test_widget_with_script_path(follower_widget_id: webpage.id, follower_widget_token: webpage.widget_token)
    sleep 1
  end

  scenario 'modal window is correct', js: true do
    click_button 'follower_widget__automatic_setup'

    expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 1')
    expect(page).to have_selector('#follower_widget__modal_confirm', text: 'I am on cart page')
    expect(page).to have_selector('#follower_widget__modal_decline', text: 'I am not on cart page')
  end

  scenario 'clicking on confirm button saves current URL (without secret param)', js: true do
    click_button 'follower_widget__automatic_setup'
    page.find("#follower_widget__modal_confirm").click
    click_button 'follower_widget__collapse_button'

    expect(page).to have_selector('#follower_widget__params_url img.follower_widget__params_success')
  end

  scenario 'clicking on confirm button opens modal of next step', js: true do
    click_button 'follower_widget__automatic_setup'

    page.find("#follower_widget__modal_confirm").click

    expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 2')
  end

  scenario 'clicking on decline button terminates automatic setup', js: true do
    click_button 'follower_widget__automatic_setup'

    page.find("#follower_widget__modal_decline").click

    expect(page).not_to have_selector('follower_widget__modal')
    expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'START AUTOMATIC SETUP')
  end
end
