class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string     :body_md,          null: false, default: ""
      t.string     :body_html,        null: false, default: ""
      t.datetime   :created_at,       null: false
      t.datetime   :updated_at,       null: true,  default: nil
      t.string     :url,              null: true,  default: nil
      t.references :created_by,       null: false
      t.integer    :lock_version,     null: false, default: 0 # use optimistic lock

      t.timestamps
    end
    add_foreign_key :comments, :users, column: "created_by_id"
  end
end
