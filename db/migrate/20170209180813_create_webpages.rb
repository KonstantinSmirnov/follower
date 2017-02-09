class CreateWebpages < ActiveRecord::Migration[5.0]
  def change
    create_table :webpages do |t|
      t.string :url
      t.string :auth_hash

      t.timestamps
    end
  end
end
