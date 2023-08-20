class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards, id: :string do |t|
      t.timestamps
    end
  end
end
