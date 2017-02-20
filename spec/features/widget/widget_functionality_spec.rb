require 'rails_helper'

feature 'WIDGET' do
  context 'setup automatically' do
    let!(:webpage) { FactoryGirl.create(:webpage_with_script) }

    scenario 'it has start setup button', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'START AUTOMATIC SETUP')
        page.execute_script "window.close();"
      end
    end

    scenario 'it hides widget after pressed automatic setup button', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        click_button 'follower_widget__automatic_setup'
        expect(find('#follower_widget__root').native.css_value('right')).to eq('-300px')
        page.execute_script 'window.close();'
      end
    end

    scenario 'it changes start automatic setup button text after starting', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        click_button 'follower_widget__automatic_setup'
        click_button 'follower_widget__collapse_button'
        expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'STOP AUTOMATIC SETUP')
        page.execute_script 'window.close();'
      end
    end

    scenario 'it changes start automatic setup button color after starting', js: true do
      skip
    end

    scenario 'it changes start automatic setup button text after stopping', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        click_button 'follower_widget__automatic_setup'
        click_button 'follower_widget__collapse_button'
        click_button 'follower_widget__automatic_setup'
        expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'START AUTOMATIC SETUP')
        page.execute_script 'window.close();'
      end
    end

    scenario 'it changes start automatic setup button color after stopping', js: true do
      skip
    end

    scenario 'it shows modal window after pressing automatic setup button', js: true do
      skip
    end

    scenario 'it automatically closes modal window if pressed button stop automatic setup', js: true do
      skip
    end

    context 'automatic setup modal window' do
      scenario 'it has action button', js: true do
        skip
      end

      scenario 'it has decline button', js: true do
        skip
      end

      scenario 'it has close modal button', js: true do
        skip
      end
    end

  end
end
