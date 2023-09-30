class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :passcode_digest, null: false, index: { unique: true }
      t.string :remember_token_digest

      t.timestamps
    end
  end
end
