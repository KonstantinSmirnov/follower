require 'rails_helper'

feature 'WEBPAGE SETTINGS', js: true do
  let(:user) { FactoryGirl.create(:user, password: 'password', password_confirmation: 'password') }
  let!(:webpage) { FactoryGirl.create(:webpage, user: user) }

  before(:each) do
    user.activate!
    log_in_with(user.email, 'password')
    visit edit_workspace_webpage_path(webpage)
  end

  scenario 'it has settings page' do
    expect(current_path).to eq(edit_workspace_webpage_path(webpage))
    expect(page).to have_selector('.nav-tabs-custom .nav-item .nav-link.active', text: 'Settings')
  end

  context 'UPDATE GENERAL DATA' do
    scenario 'fails without webpage name' do
      fill_in 'webpage_name', with: ''
      fill_in 'webpage_url', with: 'http://test.com'
      click_button 'Update'

      expect(page).to have_text("Name can't be blank")
    end

    scenario 'fails without webpage url' do
      fill_in 'webpage_name', with: 'some text'
      fill_in 'webpage_url', with: ''
      click_button 'Update'

      expect(page).to have_text("Url can't be blank")
    end

    scenario 'updates with valid webpage name and url' do
      fill_in 'webpage_name', with: 'some text'
      fill_in 'webpage_url', with: 'http://test.com'
      click_button 'Update'

      expect(page).to have_text('Successfully updated')
    end
  end

  context 'REMOVE WEBPAGE' do
    scenario 'fails without webpage name' do
      click_link 'Remove this webpage'
      click_button 'I understand the consequences, delete it'

      expect(page).to have_selector('#modal-errors .text-danger', text: 'Entered value does not match with webpage name')
    end

    scenario 'successfully removed' do
      click_link 'Remove this webpage'
      fill_in 'webpage_name_confirmation', with: webpage.name
      click_button 'I understand the consequences, delete it'

      expect(page).to have_text('was successfully deleted')
      expect(current_path).to eq(workspace_dashboard_path)
    end
  end
end
