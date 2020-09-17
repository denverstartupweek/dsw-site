class AddIsHiddenToPresenterships < ActiveRecord::Migration[6.0]
  def change
    add_column :presenterships, :is_hidden, :boolean, default: false, null: false
    add_column :presenterships, :priority, :integer, default: 0, null: false
  end
end
