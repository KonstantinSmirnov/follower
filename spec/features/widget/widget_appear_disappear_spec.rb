require 'rails_helper'

feature 'WIDGET' do
  context '[Webpage does not contain script]' do
    let!(:webpage) { FactoryGirl.create(:webpage_without_script) }

    scenario 'does not have widget', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        expect(page).not_to have_selector('div.follower_widget_frame')
        page.execute_script "window.close();"
      end
    end
  end

  context '[Webpage contains script]' do
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
        page.execute_script "window.close();"
      end
    end

    scenario 'keeps widget if redirected on another page with script', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        expect(page).to have_selector('div.follower_widget_frame')

        # Note that here script reloads each time new page is opened
        click_link 'Another test page with script'

        expect(page).to have_selector('div.follower_widget_frame')
        page.execute_script "window.close();"
      end
    end

    scenario 'does not have widget if redirected on another page without script', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        visit root_path
        expect(page).not_to have_selector('div.follower_widget_frame')
        page.execute_script "window.close();"
      end
    end

    scenario 'has widget if page closed and opened again', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        expect(page).to have_selector('div.follower_widget_frame')
        page.execute_script "window.close();"
      end

      visit webpage.url
      expect(page).to have_selector('div.follower_widget_frame')
    end

    scenario 'adds widget cookie after opening page with secret hash', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        auth_token = page.driver.browser.manage.cookie_named('hello_world_cookie')[:value]
        expect(auth_token).not_to eq(nil)
        page.execute_script "window.close();"
      end
    end

    scenario 'added cookie is valid for one day', js: true do
      skip 'CAN BE TESTED IN CONTROLLER ONLY'
    end

    scenario 'widget disappears after logout', js: true do
      skip 'CAN NOT TEST COOKIE REMOVAL FROM LOCALHOST ON CHROME [CHROME ISSUE]'
    end

    scenario 'removes cookie if widget logout' do
      skip 'CAN NOT TEST COOKIE REMOVAL FROM LOCALHOST ON CHROME [CHROME ISSUE]'
    end

    scenario 'removes URL parameter if widget logout', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        click_button 'Log Out'
        page.driver.browser.switch_to.alert.accept
        expect(current_url).to eq(webpage.url + '?')
        page.execute_script "window.close();"
      end
    end

    scenario 'checks if widget cookie is valid', js: true do
      visit root_path

      new_window = window_opened_by { click_link 'Visit' }
      within_window new_window do
        auth_token = page.driver.browser.manage.cookie_named('hello_world_cookie')[:value]
        expect(auth_token).to eq('welcome')
        page.execute_script "window.close();"
      end
    end

  end

end
