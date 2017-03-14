class WebpageBelongsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :webpages, :user_id, :integer
  end
end
