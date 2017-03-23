class AddCartUrlToWebpage < ActiveRecord::Migration[5.0]
  def up
    add_column :webpages, :cart_url, :string
  end

  def down
    remove_column :webpages, :cart_url
  end
end
