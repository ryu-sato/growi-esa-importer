class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :screen_name
      t.string :icon
      t.string :email
      t.integer :posts_count

      t.timestamps
    end
  end
end
