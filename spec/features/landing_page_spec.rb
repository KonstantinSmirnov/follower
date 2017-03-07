require 'rails_helper'

feature 'LANDING PAGE' do
  context 'appearance' do
    before(:each) do
      visit landing_path
    end

    scenario 'it has title' do
      expect(page).to have_selector('nav .navbar-brand', text: 'Follower')
    end

    scenario 'it has sign up button' do
      expect(page).to have_selector('button.btn-primary', text: 'SIGN UP')
    end

    scenario 'it has sign in button' do
      expect(page).to have_selector('.nav-item', text: 'Sign in')
    end
  end
end
