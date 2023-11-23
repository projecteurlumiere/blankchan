class AddFullNameToBoards < ActiveRecord::Migration[7.0]
  def change
    add_column :boards, :full_name, :string
  end
end
