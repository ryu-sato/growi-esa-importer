class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string     :body_md,          null: false, default: ""
      t.string     :body_html,        null: false, default: ""
      t.datetime   :created_at,       null: false
      t.datetime   :updated_at,       null: true,  default: nil
      t.string     :url,              null: true,  default: nil
      t.references :created_by,       null: false
      t.references :post,             null: false

      # [Note] No detail info in API v1 doc
      t.integer    :stargazers_count, null: false, default: 0
      t.boolean    :star,             null: false, default: false

      t.integer    :lock_version,     null: false, default: 0 # use optimistic lock
    end
    add_foreign_key :comments, :users, column: "created_by_id"
    add_foreign_key :comments, :posts, column: "post_id"
  end
end
