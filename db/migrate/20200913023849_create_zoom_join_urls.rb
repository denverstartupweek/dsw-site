class CreateZoomJoinUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :zoom_join_urls do |t|
      t.references :zoom_event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :url, null: false

      t.timestamps
    end
    remove_column :presenterships, :virtual_join_url
    remove_column :submissions, :submitter_virtual_join_url
  end
end
