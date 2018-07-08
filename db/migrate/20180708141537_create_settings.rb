class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.string :esa_access_token
      t.string :esa_team
      t.string :crowi_access_token
      t.string :crowi_url

      t.timestamps
    end
  end
end
