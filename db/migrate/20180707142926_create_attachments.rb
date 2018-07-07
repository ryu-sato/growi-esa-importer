class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.string     :filename
      t.binary     :data, limit: 10.megabyte
      t.string     :url
      t.references :post,             null: false

      t.integer    :lock_version,     null: false, default: 0 # use optimistic lock
      t.timestamps
    end
    add_foreign_key :attachments, :posts, column: "post_id"
  end
end
