class CreateModerators < ActiveRecord::Migration[7.0]
  def change
    create_table :moderators do |t|
      t.integer :user_id
      t.string :supervised_board

      t.timestamps
    end
  end
end
