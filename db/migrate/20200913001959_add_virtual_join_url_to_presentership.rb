class AddVirtualJoinUrlToPresentership < ActiveRecord::Migration[6.0]
  def change
    add_column :presenterships, :virtual_join_url, :text
  end
end
