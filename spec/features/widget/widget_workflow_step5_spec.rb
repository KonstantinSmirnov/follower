require 'rails_helper'

feature 'WIDGET WORKFLOW STEP 5' do
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
  end

  scenario 'has correct modal window', js: true do
    expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 5')
    expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Select item link')
    expect(page).to have_selector('#follower_widget__modal_decline', text: 'Skip')
  end

  scenario 'clicking close button terminates the setup process', js: true do
    page.find('#follower_widget__modal_close').click
    page.driver.browser.switch_to.alert.accept

    expect(find('#follower_widget__automatic_setup').native.css_value('background-color')).to eq('rgba(51, 189, 239, 1)')
    expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'START AUTOMATIC SETUP')
  end

  scenario 'clicking on decline button skips this step', js: true do
    page.find('#follower_widget__modal_decline').click

    expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 6')
  end

  scenario 'clicking on confirm button starts process of selection', js: true do
    page.find('#follower_widget__modal_confirm').click
    expect(page).not_to have_selector('#follower_widget__modal')

    page.find('#follower_widget__collapse_button').click

    expect(page).not_to have_selector('#follower_widget__modal')
    expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'STOP AUTOMATIC SETUP')
  end

  scenario 'can see selected value in modal', js: true do
    page.find('#follower_widget__modal_confirm').click

    page.find('#follower_widget__test_item_link').click

    expect(page.find('#follower_widget__modal_content').text).to eq(page.find('#follower_widget__test_item_link')['href'])
  end

  scenario 'clicking on decline button allows to select another value', js: true do
    page.find('#follower_widget__modal_confirm').click

    page.find('#follower_widget__test_item_link').click
    page.find('#follower_widget__modal_decline').click
    page.find('#follower_widget__test_item_link').click

    expect(page.find('#follower_widget__modal_content').text).to eq(page.find('#follower_widget__test_item_link')['href'])
  end

  scenario 'clicking on confirm button for selected value saves it', js: true do
    page.find('#follower_widget__modal_confirm').click
    page.find('#follower_widget__test_item_link').click
    page.find('#follower_widget__modal_confirm').click

    sleep 1
    page.find('#follower_widget__collapse_button').click

    expect(page).to have_selector('#follower_widget__params_item_link img.follower_widget__params_success')
  end

  scenario 'clicking on confirm button for selected value opens the next step modal', js: true do
    page.find('#follower_widget__modal_confirm').click

    page.find('#follower_widget__test_item_link').click
    page.find('#follower_widget__modal_confirm').click

    expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 6')
  end
end
