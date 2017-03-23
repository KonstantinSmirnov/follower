class AddImageIdToWebpage < ActiveRecord::Migration[5.0]
  def up
    add_column :webpages, :item_image_id, :string
    add_column :webpages, :item_sku_id, :string
    add_column :webpages, :item_name_id, :string
    add_column :webpages, :item_link_id, :string
    add_column :webpages, :item_quantity_id, :string
    add_column :webpages, :delivery_price_id, :string
    add_column :webpages, :cart_total_id, :string
  end

  def down
    remove_column :webpages, :item_image_id
    remove_column :webpages, :item_sku_id
    remove_column :webpages, :item_name_id
    remove_column :webpages, :item_link_id
    remove_column :webpages, :item_quantity_id
    remove_column :webpages, :delivery_price_id
    remove_column :webpages, :cart_total_id
  end
end
