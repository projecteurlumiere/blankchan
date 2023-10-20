class AddForPreviewToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :for_preview, :boolean, default: false
  end
end
