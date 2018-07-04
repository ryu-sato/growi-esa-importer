class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer :number,           null: false
      t.string :name,              null: false, default: ""
      t.references :tags,          null: false, default: []
      t.string :category,          null: false, default: ""
      t.string :full_name,         null: false, default: ""
      t.boolean :wip,              null: false, default: false
      t.string :body_md,           null: false, default: ""
      t.string :body_html,         null: false, default: ""
      t.datetime :created_at,      null: false
      t.datetime :updated_at,      null: false
      t.string :url,               null: false, default: ""
      t.string :message,           null: false, default: ""
      t.integer :revision_number,  null: false
      t.references :created_by,    null: false
      t.references :updated_by,    null: false
      t.string :kind,              null: false, default: ""
      t.integer :comments_count,   null: false
      t.integer :tasks_count,      null: false
      t.integer :done_tasks_count, null: false
      t.integer :stargazers_count, null: false
      t.integer :watchers_count,   null: false
      t.boolean :star,             null: false, default: false
      t.boolean :watch,            null: false, default: false

      t.timestamps
    end
    add_foreign_key :created_by, :user
    add_foreign_key :updated_by, :user
  end
end
