class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name,         null: false, default: ""
      t.string :screen_name,  null: false, default: ""
      t.string :icon,         null: false, default: ""
      t.string :email,        null: false, default: ""
      t.integer :posts_count, null: false

      t.timestamps
    end
  end
end
