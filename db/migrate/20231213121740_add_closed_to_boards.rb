class AddClosedToBoards < ActiveRecord::Migration[7.0]
  def change
      add_column :boards, :closed, :boolean, default: false
  end
end
