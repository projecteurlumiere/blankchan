class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics do |t|
      t.integer :board_id

      t.timestamps
    end
  end
end
