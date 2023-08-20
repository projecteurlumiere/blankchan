class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.integer :topic_id
      t.string :name
      t.string :text
      t.string :pic_link

      t.timestamps
    end
  end
end
