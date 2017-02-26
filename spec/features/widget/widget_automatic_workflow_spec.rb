require 'rails_helper'

feature 'AUTOMATIC SETUP' do
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
      page.driver.browser.switch_to.alert.accept

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
      page.driver.browser.switch_to.alert.accept

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
      page.driver.browser.switch_to.alert.accept

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
        expect(page).to have_selector('#follower_widget__modal_confirm')
        expect(page).to have_selector('#follower_widget__modal_decline')

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

        page.find("#follower_widget__modal_close").click
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

        page.find("#follower_widget__modal_close").click
        page.driver.browser.switch_to.alert.accept

        expect(find('#follower_widget__automatic_setup').native.css_value('background-color')).to eq('rgba(51, 189, 239, 1)')
        expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'START AUTOMATIC SETUP')

        page.execute_script 'window.close();'
      end
    end
  end

  context 'WORKFLOW' do
    context 'STEP 1: get current URL' do
      scenario 'modal window is correct', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'

          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 1')
          expect(page).to have_selector('#follower_widget__modal_confirm', text: 'I am on cart page')
          expect(page).to have_selector('#follower_widget__modal_decline', text: 'I am not on cart page')

          page.execute_script 'window.close();'
        end
      end

      scenario 'clicking on confirm button saves current URL (without secret param)', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'

          page.find("#follower_widget__modal_confirm").click
          click_button 'follower_widget__collapse_button'
          expect(page).to have_selector('#follower_widget__params_url', text: 'http://localhost:3000/test_widget/with_script?')

          page.execute_script 'window.close();'
        end
      end

      scenario 'clicking on confirm button opens modal of next step', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'

          page.find("#follower_widget__modal_confirm").click

          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 2')

          page.execute_script 'window.close();'
        end
      end

      scenario 'clicking on decline button terminates automatic setup', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'

          page.find("#follower_widget__modal_decline").click

          expect(page).not_to have_selector('follower_widget__modal')
          expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'START AUTOMATIC SETUP')

          page.execute_script 'window.close();'
        end
      end
    end

    context 'STEP 2: get item image', js: true do
      scenario 'modal window is correct', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'
          page.find("#follower_widget__modal_confirm").click

          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 2')
          expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Select image')
          expect(page).to have_selector('#follower_widget__modal_decline', text: 'Interrupt process')

          page.execute_script 'window.close();'
        end
      end

      scenario 'clicking on decline button terminates automatic setup', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'
          page.find("#follower_widget__modal_confirm").click

          page.find("#follower_widget__modal_decline").click

          expect(page).not_to have_selector('follower_widget__modal')
          expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'START AUTOMATIC SETUP')

          page.execute_script 'window.close();'
        end
      end

      scenario 'clicking on confirm button starts process of selecting image', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'
          page.find("#follower_widget__modal_confirm").click
          page.find("#follower_widget__modal_confirm").click
          page.find("#follower_widget__collapse_button").click

          expect(page).not_to have_selector('#follower_widget__modal')
          expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'STOP AUTOMATIC SETUP')

          page.execute_script 'window.close();'
        end
      end

      scenario 'has correct modal for selected image', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'
          page.find("#follower_widget__modal_confirm").click
          page.find("#follower_widget__modal_confirm").click

          page.find("#follower_widget__test_image_1").click

          expect(page).to have_selector('#follower_widget__modal_header', text: 'Is it a correct item image?')
          expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Correct')
          expect(page).to have_selector('#follower_widget__modal_decline', text: 'Incorrect, I will try again')

          page.execute_script 'window.close();'
        end
      end

      scenario 'can see selected image in modal', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'
          page.find("#follower_widget__modal_confirm").click
          page.find("#follower_widget__modal_confirm").click

          page.find("#follower_widget__test_image_1").click

          expect(page.find("#follower_widget__modal_image")['src']).to eq(page.find("#follower_widget__test_image_1")['src'])

          page.execute_script 'window.close();'
        end
      end

      scenario 'has warning message if was not selected image', js: true do
        skip
      end

      scenario 'clicking on confirm button for selected image saves image URL', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'

          page.find("#follower_widget__modal_confirm").click
          page.find("#follower_widget__modal_confirm").click
          page.find("#follower_widget__test_image_1").click
          page.find("#follower_widget__modal_confirm").click

          sleep 1
          page.find("#follower_widget__collapse_button").click

          expect(page).to have_selector('#follower_widget__params_item_image', text: page.find("#follower_widget__test_image_1")['src'])

          page.execute_script 'window.close();'
        end
      end

      scenario 'can select another image if selected incorrect image and clicked decline button', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'
          page.find("#follower_widget__modal_confirm").click
          page.find("#follower_widget__modal_confirm").click

          page.find("#follower_widget__test_image_1").click
          page.find("#follower_widget__modal_decline").click
          page.find("#follower_widget__test_image_1").click

          expect(page.find("#follower_widget__modal_image")['src']).to eq(page.find("#follower_widget__test_image_1")['src'])

          page.execute_script 'window.close();'
        end
      end

      scenario 'clicking on confirm button for selected image opens a modal for the next step', js: true do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'
          page.find("#follower_widget__modal_confirm").click
          page.find("#follower_widget__modal_confirm").click
          page.find("#follower_widget__test_image_1").click
          page.find('#follower_widget__modal_confirm').click

          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 3')

          page.execute_script 'window.close();'
        end
      end
    end

    scenario 'STEP 3: get item link', js: true do
      skip
    end

  end
end
