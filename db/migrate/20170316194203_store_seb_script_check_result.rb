class StoreSebScriptCheckResult < ActiveRecord::Migration[5.0]
  def change
    add_column :webpages, :has_script, :boolean, default: false
  end
end
