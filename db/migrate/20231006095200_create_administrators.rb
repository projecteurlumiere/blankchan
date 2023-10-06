class CreateAdministrators < ActiveRecord::Migration[7.0]
  def change
    create_table :administrators do |t|
      t.integer :user_id
      t.string :board

      t.timestamps
    end
  end
end
