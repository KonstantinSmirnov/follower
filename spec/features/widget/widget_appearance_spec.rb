require 'rails_helper'

feature 'WIDGET APPEARANCE' do
  context 'Webpage contains script' do
    let!(:webpage) { FactoryGirl.create(:webpage_with_script) }

    before(:each) do
      visit webpage.url + '?hello_world=welcome'
    end

    scenario 'widget has title', js: true do
      expect(page).to have_selector('h1', text: 'Follower')
    end

    scenario 'widget can be hidden and unhidden', js: true do
      expect(page).to have_selector('#follower_widget_collapse_button', text: '>')
      expect(find("#follower_widget_root").native.css_value('right')).to eq('0px')

      click_button 'follower_widget_collapse_button'

      expect(page).to have_selector('#follower_widget_collapse_button', text: '<')
      expect(find("#follower_widget_root").native.css_value('right')).to eq('-300px')

      click_button 'follower_widget_collapse_button'

      expect(page).to have_selector('#follower_widget_collapse_button', text: '>')
      expect(find("#follower_widget_root").native.css_value('right')).to eq('0px')
    end

    scenario 'widget can be horizontal'

    scenario 'widget can be vertical'

    scenario 'widget can be closed (logout)', js: true do
      skip 'Can not be tested because can not delete cookies on localhost'
    end
  end
end
