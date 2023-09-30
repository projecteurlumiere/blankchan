class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics do |t|
      t.integer :board_id, null: false

      t.timestamps
    end
  end
end
