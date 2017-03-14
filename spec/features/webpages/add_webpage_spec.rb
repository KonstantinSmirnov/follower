require 'rails_helper'

feature 'ADD WEBPAGE' do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    user.activate!
    user.password = 'password'
    user.password_confirmation = 'password'
    user.save
    log_in_with(user.email, 'password')
    visit workspace_dashboard_path
  end

  scenario 'workspace has a link' do
    expect(page).to have_selector('.nav-item.active .nav-link', text: 'Workspace')
    expect(current_path).to eq(workspace_dashboard_path)
  end

  scenario 'has modal window for new webpage form', js: true do
    click_link 'add-new-page-button'

    expect(page).to have_selector('#modal .modal-title', text: "Add new page")
  end

  scenario 'fails without page name', js: true do
    click_link 'add-new-page-button'

    fill_in 'webpage_url', with: 'http://test.com'
    click_button 'Save'

    expect(page).to have_selector('.text-danger', text: "Name can't be blank")
    expect(current_path).to eq(workspace_dashboard_path)
  end

  scenario 'fails without page url', js: true do
    click_link 'add-new-page-button'

    fill_in 'webpage_name', with: 'Test webpage'
    click_button 'Save'

    expect(page).to have_selector('.text-danger', text: "Url can't be blank")
    expect(current_path).to eq(workspace_dashboard_path)
  end

  scenario 'added with valid name and url', js: true do
    click_link 'add-new-page-button'

    webpage_name = 'Test webpage'
    fill_in 'webpage_name', with: webpage_name
    fill_in 'webpage_url', with: 'http://test.com'
    click_button 'Save'
    sleep 1
    webpage = Webpage.last

    expect(page).to have_text('You have added new web page')
    expect(page).to have_selector('.nav-item .nav-link.active', text: webpage_name)
    expect(page).to have_selector('h2', webpage_name )
    expect(current_path).to eq(workspace_webpage_path(webpage))
  end

  scenario 'added webpage belongs to current user', js: true do
    click_link 'add-new-page-button'

    fill_in 'webpage_name', with: 'Test webpage'
    fill_in 'webpage_url', with: 'http://test.com'
    click_button 'Save'

    sleep 1
    webpage = Webpage.last

    expect(webpage.user).to eq(user)
  end

  scenario 'added webpage is visible only to added it user', js: true do
    click_link 'add-new-page-button'

    webpage_name = 'This is a test web page'
    fill_in 'webpage_name', with: webpage_name
    fill_in 'webpage_url', with: 'http://test.com'
    click_button 'Save'

    expect(page).to have_text('This is a test web page')

    another_user = FactoryGirl.create(:user, email: 'another@email.com')
    another_user.activate!
    another_user.password = 'password'
    another_user.password_confirmation = 'password'
    another_user.save
    log_in_with(another_user.email, 'password')
    visit workspace_dashboard_path

    expect(page).not_to have_text('This is a test web page')
  end
end
