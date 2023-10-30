class RenameAuthorStatusIntoUserIdInPost < ActiveRecord::Migration[7.0]
  def change
    change_table :posts do |t|
      t.rename :author_status, :author_id
    end
  end
end
