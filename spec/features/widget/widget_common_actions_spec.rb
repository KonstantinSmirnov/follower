require 'rails_helper'

feature 'AUTOMATIC SETUP' do
  let!(:user) { FactoryGirl.create(:user, password: 'password', password_confirmation: 'password') }
  let!(:webpage) { FactoryGirl.create(:webpage_with_script, user: user) }

  before(:each) do
    user.activate!
    log_in_with(user.email, 'password')

    visit test_widget_with_script_path(follower_widget_id: webpage.id, follower_widget_token: webpage.widget_token)
  end

  scenario 'it has start setup button', js: true do
    expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'START AUTOMATIC SETUP')
  end

  scenario 'it hides widget after pressed automatic setup button', js: true do
    click_button 'follower_widget__automatic_setup'
    expect(find('#follower_widget__root').native.css_value('right')).to eq('-300px')
  end

  scenario 'it changes start automatic setup button text after starting', js: true do
    click_button 'follower_widget__automatic_setup'
    click_button 'follower_widget__collapse_button'
    expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'STOP AUTOMATIC SETUP')
  end

  scenario 'it changes start automatic setup button text after stopping', js: true do
    click_button 'follower_widget__automatic_setup'
    click_button 'follower_widget__collapse_button'
    click_button 'follower_widget__automatic_setup'
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'START AUTOMATIC SETUP')
  end

  scenario 'it changes start automatic setup button color after starting and stopping', js: true do
    click_button 'follower_widget__automatic_setup'
    click_button 'follower_widget__collapse_button'

    expect(find('#follower_widget__automatic_setup').native.css_value('background-color')).to eq('rgba(255, 0, 0, 1)')

    click_button 'follower_widget__automatic_setup'
    page.driver.browser.switch_to.alert.accept

    expect(find('#follower_widget__automatic_setup').native.css_value('background-color')).to eq('rgba(51, 189, 239, 1)')
  end

  scenario 'it shows modal window after pressing automatic setup button', js: true do
    click_button 'follower_widget__automatic_setup'

    expect(page).to have_selector('#follower_widget__overlay')
    expect(page).to have_selector('#follower_widget__modal')
  end

  scenario 'it automatically closes modal window if pressed button stop automatic setup', js: true do
    click_button 'follower_widget__automatic_setup'

    expect(page).to have_selector('#follower_widget__overlay')
    expect(page).to have_selector('#follower_widget__modal')

    click_button 'follower_widget__collapse_button'
    click_button 'follower_widget__automatic_setup'
    page.driver.browser.switch_to.alert.accept

    expect(page).not_to have_selector('#follower_widget__overlay')
    expect(page).not_to have_selector('#follower_widget__modal')
  end

  context 'automatic setup modal window' do
    scenario 'it has action and decline buttons', js: true do
      click_button 'follower_widget__automatic_setup'

      expect(page).to have_selector('#follower_widget__modal')
      expect(page).to have_selector('#follower_widget__modal_confirm')
      expect(page).to have_selector('#follower_widget__modal_decline')
    end

    scenario 'it hides modal window after pressing close button', js: true do
      click_button 'follower_widget__automatic_setup'

      expect(page).to have_selector('#follower_widget__overlay')
      expect(page).to have_selector('#follower_widget__modal')

      page.find("#follower_widget__modal_close").click
      page.driver.browser.switch_to.alert.accept

      expect(page).not_to have_selector('#follower_widget__overlay')
      expect(page).not_to have_selector('#follower_widget__modal')
    end

    scenario 'it stops automatic setup if pressed close button', js: true do
      click_button 'follower_widget__automatic_setup'

      expect(page).to have_selector('#follower_widget__modal')

      page.find("#follower_widget__modal_close").click
      page.driver.browser.switch_to.alert.accept

      expect(find('#follower_widget__automatic_setup').native.css_value('background-color')).to eq('rgba(51, 189, 239, 1)')
      expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'START AUTOMATIC SETUP')
    end
  end
end
