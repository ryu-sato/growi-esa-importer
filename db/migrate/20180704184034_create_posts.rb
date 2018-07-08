class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer    :number,           null: false, default: 0
      t.string     :name,             null: false, default: ""
      t.text       :tags,             null: false, array: true, default: [].to_yaml
      t.string     :category,         null: true,  default: nil
      t.string     :full_name,        null: false, default: ""
      t.boolean    :wip,              null: false, default: false
      t.string     :body_md,          null: false, default: ""
      t.string     :body_html,        null: false, default: ""
      t.datetime   :created_at,       null: false
      t.datetime   :updated_at,       null: true,  default: nil
      t.string     :url,              null: false, default: ""
      t.string     :message,          null: false, default: ""
      t.integer    :revision_number,  null: false, default: 0
      t.references :created_by,       null: false
      t.references :updated_by,       null: false
      t.string     :kind,             null: false, default: ""
      t.integer    :comments_count,   null: false, default: 0
      t.integer    :tasks_count,      null: false, default: 0
      t.integer    :done_tasks_count, null: false, default: 0
      t.integer    :stargazers_count, null: false, default: 0
      t.integer    :watchers_count,   null: false, default: 0
      t.boolean    :star,             null: false, default: false
      t.boolean    :watch,            null: false, default: false

      t.integer    :lock_version,     null: false, default: 0  # use optimistic lock
    end
    add_foreign_key :posts, :users, column: "created_by_id"
    add_foreign_key :posts, :users, column: "updated_by"
  end
end
