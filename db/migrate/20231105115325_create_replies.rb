class CreateReplies < ActiveRecord::Migration[7.0]
  def change
    create_table :replies do |t|
      t.references :post, null: false, foreign_key: true
      t.references :reply, null: false, foreign_key: { to_table: :posts}
      t.timestamps
    end
  end
end
