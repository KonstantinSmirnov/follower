class AddNameToWebpage < ActiveRecord::Migration[5.0]
  def change
    add_column :webpages, :name, :string
  end
end
