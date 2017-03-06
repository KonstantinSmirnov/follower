require 'rails_helper'

feature 'WIDGET APPEARANCE' do
  context 'Webpage contains script' do
    let!(:webpage) { FactoryGirl.create(:webpage_with_script) }

    before(:each) do
      visit webpage.url + '?hello_world=welcome'
    end

    scenario 'widget has title', js: true do
      expect(page).to have_selector('h4', text: 'Follower')
    end

    scenario 'widget has params', js: true do
      # Params header
      expect(page).to have_selector('#follower_widget__params_header', text: 'PARAMETERS')
      # CartURL
      expect(page).to have_selector('#follower_widget__params_url', text: 'URL:')
      # Item image
      expect(page).to have_selector('#follower_widget__params_item_image', text: 'Item Image:')
      # Item sku
      expect(page).to have_selector('#follower_widget__params_item_sku', text: 'Item SKU:')
      # Item name
      expect(page).to have_selector('#follower_widget__params_item_name', text: 'Item Name:')
      # Item link
      expect(page).to have_selector('#follower_widget__params_item_link', text: 'Item Link:')
      # Item quantity
      expect(page).to have_selector('#follower_widget__params_item_quantity', text: 'Item Quantity:')
      # Cart delivery
      expect(page).to have_selector('#follower_widget__params_cart_delivery', text: 'Delivery Price:')
      # Cart total
      expect(page).to have_selector('#follower_widget__params_cart_total', text: 'Cart Total:')
    end

    scenario 'widget can be hidden and unhidden', js: true do
      expect(page).to have_selector('#follower_widget__collapse_button', text: '>')
      expect(find("#follower_widget__root").native.css_value('right')).to eq('0px')

      click_button 'follower_widget__collapse_button'

      expect(page).to have_selector('#follower_widget__collapse_button', text: '<')
      expect(find("#follower_widget__root").native.css_value('right')).to eq('-300px')

      click_button 'follower_widget__collapse_button'

      expect(page).to have_selector('#follower_widget__collapse_button', text: '>')
      expect(find("#follower_widget__root").native.css_value('right')).to eq('0px')
    end

    scenario 'widget can be horizontal'

    scenario 'widget can be vertical'

    scenario 'widget can be closed (logout)', js: true do
      skip 'Can not be tested because can not delete cookies on localhost'
    end
  end
end
