class AddItemGotUserToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :item_got_user, :string
  end
end
