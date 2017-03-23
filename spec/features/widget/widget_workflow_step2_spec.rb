require 'rails_helper'

feature 'WIDGET WORKFLOW STEP 2' do
  let!(:user) { FactoryGirl.create(:user, password: 'password', password_confirmation: 'password') }
  let!(:webpage) { FactoryGirl.create(:webpage_with_script, user: user) }

  before(:each) do
    user.activate!
    log_in_with(user.email, 'password')

    visit test_widget_with_script_path(follower_widget_id: webpage.id, follower_widget_token: webpage.widget_token)
    sleep 1
    click_button 'follower_widget__automatic_setup'
    page.find("#follower_widget__modal_confirm").click
  end

  scenario 'has correct modal window', js: true do
    expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 2')
    expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Select image')
    expect(page).to have_selector('#follower_widget__modal_decline', text: 'Skip')
  end

  scenario 'clicking on decline button skips this step', js: true do
    page.find("#follower_widget__modal_decline").click

    expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 3')
  end

  scenario 'clicking on confirm button starts process of selecting image', js: true do
    page.find("#follower_widget__modal_confirm").click
    page.find("#follower_widget__collapse_button").click

    expect(page).not_to have_selector('#follower_widget__modal')
    expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'STOP AUTOMATIC SETUP')
  end

  scenario 'has correct modal for selected image', js: true do
    page.find("#follower_widget__modal_confirm").click
    page.find("#follower_widget__test_image_1").click

    expect(page).to have_selector('#follower_widget__modal_header', text: 'Is it a correct item image?')
    expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Correct')
    expect(page).to have_selector('#follower_widget__modal_decline', text: 'Incorrect, I will try again')
  end

  scenario 'can see selected image in modal', js: true do
    page.find("#follower_widget__modal_confirm").click
    page.find("#follower_widget__test_image_1").click

    expect(page.find("#follower_widget__modal_image")['src']).to eq(page.find("#follower_widget__test_image_1")['src'])
  end

  scenario 'has warning message if was selected not an image'

  scenario 'clicking on confirm button for selected image saves image URL', js: true do
    page.find("#follower_widget__modal_confirm").click
    page.find('#follower_widget__test_image_1').click
    page.find("#follower_widget__modal_confirm").click

    sleep 1
    page.find("#follower_widget__collapse_button").click
    webpage.reload

    expect(page).to have_selector('#follower_widget__params_item_image img.follower_widget__params_success')
    expect(webpage.item_image_id.to_s).to include('follower_widget__test_image_1')

    visit workspace_webpage_path(webpage)

    expect(page).to have_selector('td', text: 'follower_widget__test_image_1')
  end

  scenario 'can select another image if selected incorrect image and clicked decline button', js: true do
    page.find("#follower_widget__modal_confirm").click

    page.find("#follower_widget__test_image_1").click
    page.find("#follower_widget__modal_decline").click
    page.find("#follower_widget__test_image_1").click

    expect(page.find("#follower_widget__modal_image")['src']).to eq(page.find("#follower_widget__test_image_1")['src'])
  end

  scenario 'clicking on confirm button for selected image opens a modal for the next step', js: true do
    page.find("#follower_widget__modal_confirm").click
    page.find("#follower_widget__test_image_1").click
    page.find('#follower_widget__modal_confirm').click

    expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 3')
  end
end
