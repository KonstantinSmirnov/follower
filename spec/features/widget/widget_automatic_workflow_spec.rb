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
      before(:each) do
        visit root_path

        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          click_button 'follower_widget__automatic_setup'
          page.find("#follower_widget__modal_confirm").click
        end
      end
      after(:each) do
        page.execute_script 'window.close();'
      end

      scenario 'has correct modal window' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 2')
          expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Select image')
          expect(page).to have_selector('#follower_widget__modal_decline', text: 'Skip')
        end
      end

      scenario 'clicking on decline button skips this step' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          page.find("#follower_widget__modal_decline").click

          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 3')
        end
      end

      scenario 'clicking on confirm button starts process of selecting image' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          page.find("#follower_widget__modal_confirm").click
          page.find("#follower_widget__collapse_button").click

          expect(page).not_to have_selector('#follower_widget__modal')
          expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'STOP AUTOMATIC SETUP')
        end
      end

      scenario 'has correct modal for selected image' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          page.find("#follower_widget__modal_confirm").click

          page.find("#follower_widget__test_image_1").click

          expect(page).to have_selector('#follower_widget__modal_header', text: 'Is it a correct item image?')
          expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Correct')
          expect(page).to have_selector('#follower_widget__modal_decline', text: 'Incorrect, I will try again')
        end
      end

      scenario 'can see selected image in modal' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          page.find("#follower_widget__modal_confirm").click

          page.find("#follower_widget__test_image_1").click

          expect(page.find("#follower_widget__modal_image")['src']).to eq(page.find("#follower_widget__test_image_1")['src'])
        end
      end

      scenario 'has warning message if was selected not an image' do
        skip
      end

      scenario 'clicking on confirm button for selected image saves image URL' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          page.find("#follower_widget__modal_confirm").click
          page.find("#follower_widget__test_image_1").click
          page.find("#follower_widget__modal_confirm").click

          sleep 1
          page.find("#follower_widget__collapse_button").click

          expect(page).to have_selector('#follower_widget__params_item_image', text: page.find("#follower_widget__test_image_1")['src'])
        end
      end

      scenario 'can select another image if selected incorrect image and clicked decline button' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          page.find("#follower_widget__modal_confirm").click

          page.find("#follower_widget__test_image_1").click
          page.find("#follower_widget__modal_decline").click
          page.find("#follower_widget__test_image_1").click

          expect(page.find("#follower_widget__modal_image")['src']).to eq(page.find("#follower_widget__test_image_1")['src'])
        end
      end

      scenario 'clicking on confirm button for selected image opens a modal for the next step' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          page.find("#follower_widget__modal_confirm").click
          page.find("#follower_widget__test_image_1").click
          page.find('#follower_widget__modal_confirm').click

          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 3')
        end
      end
    end

    context 'STEP 3: get item sku', js: true do
      before(:each) do
        visit root_path
        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          # Starts automatic setup
          click_button 'follower_widget__automatic_setup'
          # Confirms STEP 1
          page.find('#follower_widget__modal_confirm').click
          # Skip STEP 2 select image
          page.find('#follower_widget__modal_decline').click
        end
      end
      after(:each) do
        page.execute_script 'window.close();'
      end

      scenario 'has correct modal window' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 3')
          expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Select SKU')
          expect(page).to have_selector('#follower_widget__modal_decline', text: 'Skip')
        end
      end

      scenario 'clicking close button terminates the setup process' do
        new_window = page.driver.browser.window_handles.last
        within_window new_window do
          page.find("#follower_widget__modal_close").click
          page.driver.browser.switch_to.alert.accept

          expect(find('#follower_widget__automatic_setup').native.css_value('background-color')).to eq('rgba(51, 189, 239, 1)')
          expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'START AUTOMATIC SETUP')
        end
      end

      scenario 'clicking on decline button skips this step' do
        new_window = page.driver.browser.window_handles.last
        within_window new_window do
          page.find('#follower_widget__modal_decline').click

          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 4')
        end
      end

      scenario 'clicking on confirm button starts process of selection' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          page.find("#follower_widget__modal_confirm").click
          expect(page).not_to have_selector('#follower_widget__modal')

          page.find("#follower_widget__collapse_button").click

          expect(page).not_to have_selector('#follower_widget__modal')
          expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'STOP AUTOMATIC SETUP')
        end
      end

      scenario 'can see selected value in modal' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          page.find("#follower_widget__modal_confirm").click

          page.find("#follower_widget__test_item_sku").click

          expect(page.find("#follower_widget__modal_content").text).to eq(page.find("#follower_widget__test_item_sku").text)
        end
      end

      scenario 'clicking on decline button allows to select another value' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          page.find("#follower_widget__modal_confirm").click

          page.find("#follower_widget__test_item_sku").click
          page.find("#follower_widget__modal_decline").click
          page.find("#follower_widget__test_item_sku").click

          expect(page.find("#follower_widget__modal_content").text).to eq(page.find("#follower_widget__test_item_sku").text)
        end
      end
      scenario 'clicking on confirm button for selected value saves it' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          page.find("#follower_widget__modal_confirm").click
          page.find("#follower_widget__test_item_sku").click
          page.find("#follower_widget__modal_confirm").click

          sleep 1
          page.find("#follower_widget__collapse_button").click

          expect(page).to have_selector('#follower_widget__params_item_sku', text: page.find("#follower_widget__test_item_sku").text)
        end
      end

      scenario 'clicking on confirm button for selected value opens the next step modal' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          page.find("#follower_widget__modal_confirm").click

          page.find("#follower_widget__test_item_sku").click
          page.find("#follower_widget__modal_confirm").click

          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 4')
        end
      end
    end

    context 'STEP 4: get item name', js: true do
      before(:each) do
        visit root_path
        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          # Starts automatic setup
          click_button 'follower_widget__automatic_setup'
          # Confirms STEP 1
          page.find('#follower_widget__modal_confirm').click
          # Skip STEP 2 select image
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 3
          page.find('#follower_widget__modal_decline').click
        end
      end
      after(:each) do
        page.execute_script 'window.close();'
      end

      scenario 'has correct modal window' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 4')
          expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Select item name')
          expect(page).to have_selector('#follower_widget__modal_decline', text: 'Skip')
        end
      end

      scenario 'clicking close button terminates the setup process'
      scenario 'clicking on decline button skips this step'
      scenario 'clicking on confirm button starts process of selection'
      scenario 'can see selected value in modal'
      scenario 'clicking on decline button allows to select another value'
      scenario 'clicking on confirm button for selected value saves it'
      scenario 'clicking on confirm button for selected value opens the next step modal'
    end

    context 'STEP 5: get item link', js: true do
      before(:each) do
        visit root_path
        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          # Starts automatic setup
          click_button 'follower_widget__automatic_setup'
          # Confirms STEP 1
          page.find('#follower_widget__modal_confirm').click
          # Skip STEP 2 select image
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 3
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 4
          page.find('#follower_widget__modal_decline').click
        end
      end
      after(:each) do
        page.execute_script 'window.close();'
      end

      scenario 'has correct modal window' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 5')
          expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Select item link')
          expect(page).to have_selector('#follower_widget__modal_decline', text: 'Skip')
        end
      end
      scenario 'clicking close button terminates the setup process'
      scenario 'clicking on decline button skips this step'
      scenario 'clicking on confirm button starts process of selection'
      scenario 'can see selected value in modal'
      scenario 'clicking on decline button allows to select another value'
      scenario 'clicking on confirm button for selected value saves it'
      scenario 'clicking on confirm button for selected value opens the next step modal'
    end

    context 'STEP 6: get item quantity', js: true do
      before(:each) do
        visit root_path
        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          # Starts automatic setup
          click_button 'follower_widget__automatic_setup'
          # Confirms STEP 1
          page.find('#follower_widget__modal_confirm').click
          # Skip STEP 2 select image
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 3
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 4
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 5
          page.find('#follower_widget__modal_decline').click
        end
      end
      after(:each) do
        page.execute_script 'window.close();'
      end

      scenario 'has correct modal window' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 6')
          expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Select item quantity')
          expect(page).to have_selector('#follower_widget__modal_decline', text: 'Skip')
        end
      end

      scenario 'clicking close button terminates the setup process'
      scenario 'clicking on decline button skips this step'
      scenario 'clicking on confirm button starts process of selection'
      scenario 'can see selected value in modal'
      scenario 'clicking on decline button allows to select another value'
      scenario 'clicking on confirm button for selected value saves it'
      scenario 'clicking on confirm button for selected value opens the next step modal'
    end

    context 'STEP 7: get cart total', js: true do
      before(:each) do
        visit root_path
        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          # Starts automatic setup
          click_button 'follower_widget__automatic_setup'
          # Confirms STEP 1
          page.find('#follower_widget__modal_confirm').click
          # Skip STEP 2 select image
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 3
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 4
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 5
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 6
          page.find('#follower_widget__modal_decline').click
        end
      end
      after(:each) do
        page.execute_script 'window.close();'
      end

      scenario 'has correct modal window' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 7')
          expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Select cart total')
          expect(page).to have_selector('#follower_widget__modal_decline', text: 'Skip')
        end
      end
      scenario 'clicking close button terminates the setup process'
      scenario 'clicking on decline button skips this step'
      scenario 'clicking on confirm button starts process of selection'
      scenario 'can see selected value in modal'
      scenario 'clicking on decline button allows to select another value'
      scenario 'clicking on confirm button for selected value saves it'
      scenario 'clicking on confirm button for selected value opens the next step modal'
    end

    context 'STEP 8: delivery price', js: true do
      before(:each) do
        visit root_path
        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          # Starts automatic setup
          click_button 'follower_widget__automatic_setup'
          # Confirms STEP 1
          page.find('#follower_widget__modal_confirm').click
          # Skip STEP 2 select image
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 3
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 4
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 5
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 6
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 7
          page.find('#follower_widget__modal_decline').click
        end
      end
      after(:each) do
        page.execute_script 'window.close();'
      end

      scenario 'has correct modal window' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 8')
          expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Select delivery price')
          expect(page).to have_selector('#follower_widget__modal_decline', text: 'Skip')
        end
      end

      scenario 'clicking close button terminates the setup process'
      scenario 'clicking on decline button skips this step'
      scenario 'clicking on confirm button starts process of selection'
      scenario 'can see selected value in modal'
      scenario 'clicking on decline button allows to select another value'
      scenario 'clicking on confirm button for selected value saves it'
      scenario 'clicking on confirm button for selected value opens the next step modal'
    end

    context 'STEP 9: final message', js: true do
      before(:each) do
        visit root_path
        new_window = window_opened_by { click_link 'Visit' }
        within_window new_window do
          # Starts automatic setup
          click_button 'follower_widget__automatic_setup'
          # Confirms STEP 1
          page.find('#follower_widget__modal_confirm').click
          # Skip STEP 2 select image
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 3
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 4
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 5
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 6
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 7
          page.find('#follower_widget__modal_decline').click
          # Skip STEP 8
          page.find('#follower_widget__modal_decline').click
        end
      end
      after(:each) do
        page.execute_script 'window.close();'
      end

      scenario 'has correct modal window with final message' do
        new_window=page.driver.browser.window_handles.last
        within_window new_window do
          expect(page).to have_selector('#follower_widget__modal_header', text: 'STEP 9')
          expect(page).to have_selector('#follower_widget__modal_confirm', text: 'Finish')
          expect(page).not_to have_selector('#follower_widget__modal_decline')
        end
      end

      scenario 'clicking on confirm button finishes the process' do
        new_window = page.driver.browser.window_handles.last
        within_window new_window do
          page.find('#follower_widget__modal_confirm').click

          expect(page).not_to have_selector('#follower_widget__modal')
          expect(page).to have_selector('#follower_widget__collapse_button', text: '>')
          expect(page).to have_selector('button#follower_widget__automatic_setup', text: 'START AUTOMATIC SETUP')
        end
      end
    end

    # Страница корзины:
    #   sku (артикул) step 3
    #   item_name (Наименование) step 4
    #   image_thumb(мини-эскиз товара , если есть - src=) = step 2
    #   item_link (ссылка на товар) step 5
    #   quantity Количество step 6
    #   total - сумма корзины step 7
    #   delivery - стоимость доставки step 8

  end
end
