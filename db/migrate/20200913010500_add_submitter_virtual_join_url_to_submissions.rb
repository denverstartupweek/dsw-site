class AddSubmitterVirtualJoinUrlToSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :submissions, :submitter_virtual_join_url, :text
  end
end
