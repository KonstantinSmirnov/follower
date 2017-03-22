require 'rails_helper'

feature 'WEBPAGE SCRIPT' do
  let(:user) { FactoryGirl.create(:user, password: 'password', password_confirmation: 'password') }
  let!(:webpage) { FactoryGirl.create(:webpage, user: user) }

  before(:each) do
    user.activate!
    log_in_with(user.email, 'password')
    visit edit_workspace_webpage_path(webpage)
  end

  context 'Webpage' do
    scenario 'contains script to add widget to external webpage' do
      visit workspace_webpage_path(webpage)

      expect(page).to have_selector('.card-header', text: 'STEP 1')
      expect(page).to have_selector('#follower_widget__script')
    end

    context 'checks if script was added to external page' do
      scenario 'has check script status button' do
        visit workspace_webpage_path(webpage)

        expect(page).to have_selector('#widget_script_status_button.btn.btn-primary', text: 'Check script status')
      end

      scenario 'shows that is in process while processing', js: true do
        webpage.url = 'https://mail.ru'
        webpage.save
        visit workspace_webpage_path(webpage)

        find('#widget_script_status_button').click

        expect(page).to have_selector('#widget_script_status_button.btn.btn-primary', text: 'Checking...')
      end

      scenario 'fails if script was not added', js: true do
        webpage.url = 'https://mail.ru'
        webpage.save
        visit workspace_webpage_path(webpage)

        find('#widget_script_status_button').click

        sleep 1

        expect(page).to have_selector('#widget_script_status_button.btn.btn-danger', text: 'Webpage exists, script not found.')
      end

      scenario 'fails if webpage has wrong prefix [http|https]', js: true do
        webpage.url = 'http://mail.ru'
        webpage.save
        visit workspace_webpage_path(webpage)

        find('#widget_script_status_button').click

        sleep 1

        expect(page).to have_selector('#widget_script_status_button.btn.btn-danger', text: 'Incorrect webpage url.')
      end

      scenario 'fails if webpage does not exist', js: true do
        webpage.url = 'http://asdfjhasdfjkhadsf.com'
        visit workspace_webpage_path(webpage)

        find('#widget_script_status_button').click

        sleep 1

        expect(page).to have_selector('#widget_script_status_button.btn.btn-danger', text: 'Incorrect webpage url.')
      end

      scenario 'fails if webpage does not have a prefix', js: true do
        webpage.url = 'asdfjhasdfjkhadsf.com'
        visit workspace_webpage_path(webpage)

        find('#widget_script_status_button').click

        sleep 1

        expect(page).to have_selector('#widget_script_status_button.btn.btn-danger', text: 'Incorrect webpage url.')
      end

      scenario 'success if script was added', js: true do
        webpage.url = 'http://smiplay.com'
        webpage.save
        visit workspace_webpage_path(webpage)

        find('#widget_script_status_button').click

        sleep 1

        expect(page).to have_selector('#widget_script_status_button.btn.btn-success', text: 'Confirmed! Press to recheck.')
      end

      scenario 'saves result if script was found', js: true do
        webpage.url = 'http://smiplay.com'
        webpage.save

        expect(webpage[:has_script]).to eq(false)

        visit workspace_webpage_path(webpage)

        find('#widget_script_status_button').click
        sleep 1
        webpage.reload

        expect(webpage[:has_script]).to eq(true)
        expect(page).to have_selector('#widget_script_status_button.btn.btn-success', text: 'Confirmed! Press to recheck.')
      end

      scenario 'shows success button if last time script was found', js: true do
        webpage.url = 'http://smiplay.com'
        webpage.save

        visit workspace_webpage_path(webpage)
        expect(page).to have_selector('#widget_script_status_button.btn.btn-primary', text: 'Check script status')

        find('#widget_script_status_button').click
        sleep 1

        visit workspace_webpage_path(webpage)

        expect(page).to have_selector('#widget_script_status_button.btn.btn-success', text: 'Confirmed! Press to recheck.')
      end

      scenario 'does not show success button if last time script was not found', js: true do
        webpage.url = 'https://mail.ru'
        webpage.has_script = true
        webpage.save

        visit workspace_webpage_path(webpage)

        find('#widget_script_status_button').click
        sleep 1

        expect(page).to have_selector('#widget_script_status_button.btn.btn-danger', text: 'Webpage exists, script not found.')

        visit workspace_webpage_path(webpage)

        expect(page).to have_selector('#widget_script_status_button', text: 'Check script status')
      end

      scenario 'does not show success button if last time url vas invalid', js: true do
        webpage.url = 'https://invalidasdfjkhasdf.ru'
        webpage.has_script = true
        webpage.save

        visit workspace_webpage_path(webpage)

        find('#widget_script_status_button').click
        sleep 1

        expect(page).to have_selector('#widget_script_status_button.btn.btn-danger', text: 'Incorrect webpage url.')

        visit workspace_webpage_path(webpage)

        expect(page).to have_selector('#widget_script_status_button', text: 'Check script status')
      end

    end


  end

end
