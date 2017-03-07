require 'rails_helper'

feature 'LANDING PAGE' do
  context 'appearance' do
    before(:each) do
      visit landing_path
    end

    scenario 'is a root page' do
      visit root_page

      expect(page).to have_selector('nav. navbar-brand', text: 'Follower')
    end

  end
end
