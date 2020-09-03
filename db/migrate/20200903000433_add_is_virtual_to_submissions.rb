class AddIsVirtualToSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :submissions, :is_virtual, :boolean, default: false, null: false
  end
end
