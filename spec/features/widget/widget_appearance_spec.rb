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
      # CartURL setup button
      expect(page).to have_selector('#follower_widget__params_url_setup_button', text: 'SETUP')
      # Item image
      expect(page).to have_selector('#follower_widget__params_item_image', text: 'Item Image:')
      # Item image setup button
      expect(page).to have_selector('#follower_widget__params_item_image_setup_button', text: 'SETUP')
      # Item sku
      expect(page).to have_selector('#follower_widget__params_item_sku', text: 'Item SKU:')
      # Item sku setup button
      expect(page).to have_selector('#follower_widget__params_item_sku_setup_button', text: 'SETUP')
      # Item name
      expect(page).to have_selector('#follower_widget__params_item_name', text: 'Item Name:')
      # Item name setup button
      expect(page).to have_selector('#follower_widget__params_item_name_setup_button', text: 'SETUP')
      # Item link
      expect(page).to have_selector('#follower_widget__params_item_link', text: 'Item Link:')
      # Item link setup button
      expect(page).to have_selector('#follower_widget__params_item_link_setup_button', text: 'SETUP')
      # Item quantity
      expect(page).to have_selector('#follower_widget__params_item_quantity', text: 'Item Quantity:')
      # Item quantity setup button
      expect(page).to have_selector('#follower_widget__params_item_quantity_setup_button', text: 'SETUP')
      # Cart delivery
      expect(page).to have_selector('#follower_widget__params_cart_delivery', text: 'Delivery Price:')
      # Cart delivery setup button
      expect(page).to have_selector('#follower_widget__params_cart_delivery_setup_button', text: 'SETUP')
      # Cart total
      expect(page).to have_selector('#follower_widget__params_cart_total', text: 'Cart Total:')
      # Cart total setup button
      expect(page).to have_selector('#follower_widget__params_cart_total_setup_button', text: 'SETUP')
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
