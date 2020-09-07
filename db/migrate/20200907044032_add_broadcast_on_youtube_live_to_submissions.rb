class AddBroadcastOnYoutubeLiveToSubmissions < ActiveRecord::Migration[6.0]
  def up
    change_table :submissions do |t|
      t.column :broadcast_on_youtube_live, :boolean, default: false, null: false
    end
    Submission.where(year: 2020).update_all(broadcast_on_youtube_live: true)
  end

  def down
    remove_column :submissions, :broadcast_on_youtube_live
  end
end
