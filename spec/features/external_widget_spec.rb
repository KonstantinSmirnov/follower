require 'rails_helper'

feature 'WIDGET' do
  context 'Webpage does not contain script' do
    let!(:webpage) { FactoryGirl.create(:webpage_without_script) }

    scenario 'does not have widget', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        expect(page).not_to have_selector('div.follower_widget_frame')
      end
    end
  end

  context 'Webpage contains script' do
    let!(:webpage) { FactoryGirl.create(:webpage_with_script) }

    scenario 'does not have widget if url does not contain secret hash', js: true do
      visit webpage.url

      expect(page).not_to have_selector('div.follower_widget_frame')
    end

    scenario 'has widget if url contains secret hash', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        expect(page).to have_selector('div.follower_widget_frame')
      end
    end

    scenario 'has widget if redirected on another page'

    scenario 'has widget if page closed and opened again'

    scenario 'adds widget cookie after opening page'

    scenario 'adds widget cookie for one day'

    scenario 'widget disappears after logout'

    scenario 'removes cookie if widget logout'

    scenario 'removed URL parameter if widget logoit'

  end

end
