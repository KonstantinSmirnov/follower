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

    scenario 'it changes start automatic setup button color after starting and stopping', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        click_button 'follower_widget__automatic_setup'
        click_button 'follower_widget__collapse_button'

        expect(find('#follower_widget__automatic_setup').native.css_value('background-color')).to eq('rgba(255, 0, 0, 1)')

        click_button 'follower_widget__automatic_setup'

        expect(find('#follower_widget__automatic_setup').native.css_value('background-color')).to eq('rgba(51, 189, 239, 1)')

        page.execute_script 'window.close();'
      end
    end

    scenario 'it shows modal window after pressing automatic setup button', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        click_button 'follower_widget__automatic_setup'

        expect(page).to have_selector('#follower_widget__overlay')
        expect(page).to have_selector('#follower_widget__modal')

        page.execute_script 'window.close();'
      end
    end

    scenario 'it automatically closes modal window if pressed button stop automatic setup', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        click_button 'follower_widget__automatic_setup'

        expect(page).to have_selector('#follower_widget__overlay')
        expect(page).to have_selector('#follower_widget__modal')

        click_button 'follower_widget__collapse_button'
        click_button 'follower_widget__automatic_setup'

        expect(page).not_to have_selector('#follower_widget__overlay')
        expect(page).not_to have_selector('#follower_widget__modal')

        page.execute_script 'window.close();'
      end
    end

    context 'automatic setup modal window' do
      scenario 'it has action and decline buttons', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'

          expect(page).to have_selector('#follower_widget__modal')
          expect(page).to have_selector('#follower_widget__modal_submit', text: 'Ok')
          expect(page).to have_selector('#follower_widget__modal_decline', text: 'Cancel')

          page.execute_script 'window.close();'
        end
      end

      scenario 'it hides modal window after pressing close button', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'

          expect(page).to have_selector('#follower_widget__overlay')
          expect(page).to have_selector('#follower_widget__modal')

          click_link 'follower_widget__modal_close'
          page.driver.browser.switch_to.alert.accept

          expect(page).not_to have_selector('#follower_widget__overlay')
          expect(page).not_to have_selector('#follower_widget__modal')

          page.execute_script 'window.close();'
        end
      end

      scenario 'it stops automatic setup if pressed close button', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'

          expect(page).to have_selector('#follower_widget__modal')

          click_link 'follower_widget__modal_close'
          page.driver.browser.switch_to.alert.accept

          expect(find('#follower_widget__automatic_setup').native.css_value('background-color')).to eq('rgba(51, 189, 239, 1)')
          expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'START AUTOMATIC SETUP')

          page.execute_script 'window.close();'
        end
      end
    end

  end
end
