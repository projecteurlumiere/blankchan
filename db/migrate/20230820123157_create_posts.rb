class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.integer :topic_id, null: false
      t.string :name
      t.string :text, null: false
      t.string :pic_link
      t.string :author_ip
      t.string :author_status
      t.boolean :blessed, default: false

      t.timestamps
    end
  end
end
