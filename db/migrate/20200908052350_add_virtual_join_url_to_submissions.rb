class AddVirtualJoinUrlToSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :submissions, :virtual_join_url, :text
  end
end
