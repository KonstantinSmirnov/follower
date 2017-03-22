require 'rails_helper'

feature 'WEBPAGE' do
  let(:user) { FactoryGirl.create(:user, password: 'password', password_confirmation: 'password') }
  let(:webpage) { FactoryGirl.create(:webpage, user: user) }

  before(:each) do
    user.activate!
    log_in_with(user.email, 'password')
  end

  context 'Common behavior' do
    scenario 'webpage opens by click in new window', js: true do
      visit workspace_webpage_path(webpage)

      new_window = window_opened_by { find('#open_webpage_button').click }
      within_window new_window do
        expect(page.driver.browser.window_handles.size).to eq(2)
        page.execute_script 'window.close();'
      end
    end

    scenario 'unique token to be provided as a url parameter' do
      visit workspace_webpage_path(webpage)

      selector = "a#open_webpage_button[href='#{webpage.url + '?follower_widget_id=' + webpage.id.to_s + '&follower_widget_token=' + webpage.widget_token}']"
      expect(page).to have_selector(selector)
    end
  end

  context 'Has widget script' do
    scenario 'fails to open widget if webpage id is invalid' do
      visit test_widget_with_script_path(follower_widget_id: '123', follower_widget_token: webpage.widget_token)

      expect(page).not_to have_selector('#follower_widget__root')
    end

    scenario 'fails to open widget if webpage id is missing' do
      visit test_widget_with_script_path(follower_widget_id: '', follower_widget_token: webpage.widget_token)

      expect(page).not_to have_selector('#follower_widget__root')
    end

    scenario 'fails to open widget if webpage token is invalid' do
      visit test_widget_with_script_path(follower_widget_id: webpage.id, follower_widget_token: '123')

      expect(page).not_to have_selector('#follower_widget__root')
    end

    scenario 'fails to open widget if webpage token is missing' do
      visit test_widget_with_script_path(follower_widget_id: webpage.id, follower_widget_token: '')

      expect(page).not_to have_selector('#follower_widget__root')
    end

    scenario 'opens widget if webpage id and token are valid', js: true do
      webpage.url = 'http://localhost:3000/test_widget/with_script'
      webpage.save
      webpage.reload

      #visit test_widget_with_script_path(follower_widget_id: webpage.id, follower_widget_token: webpage.widget_token)
      visit workspace_webpage_path(webpage)
      find('#open_webpage_button').click
      sleep 30000
      expect(page).to have_selector('#follower_widget__script')
      expect(page).to have_selector('#follower_widget__root')
    end

    scenario 'opens widget with invalid params if already opened before'
    scenario 'opens widget without params if already opened before'
  end

  context 'Has no widget script' do

    before(:each) do
      webpage.url = 'http://localhost:3000/test_widget/without_script'
      webpage.save

      user.activate!
      log_in_with(user.email, 'password')
    end

    scenario 'opens without widget', js: true do
      visit workspace_webpage_path(webpage)

      new_window = window_opened_by { find('#open_webpage_button').click }
      within_window new_window do
        expect(page).not_to have_selector('#follower_widget__script')
        expect(page).not_to have_selector('#follower_widget__root')
        page.execute_script 'window.close();'
      end

    end
  end
end
