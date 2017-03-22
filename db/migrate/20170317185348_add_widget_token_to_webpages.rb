class AddWidgetTokenToWebpages < ActiveRecord::Migration[5.0]
  def up
    add_column :webpages, :widget_token, :string
    Webpage.all.each do |webpage|
      webpage.update_attributes(widget_token: SecureRandom.hex)
    end
  end

  def down
    remove_column :webpages, :widget_token
  end
end
