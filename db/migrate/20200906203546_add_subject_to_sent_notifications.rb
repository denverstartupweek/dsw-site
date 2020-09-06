class AddSubjectToSentNotifications < ActiveRecord::Migration[6.0]
  def up
    add_reference :sent_notifications, :subject, polymorphic: true
    SentNotification.update_all("subject_id = submission_id, subject_type = 'Submission'")
    change_column_null(:sent_notifications, :subject_id, false)
    change_column_null(:sent_notifications, :subject_type, false)
    remove_column :sent_notifications, :submission_id
  end

  def down
    change_table(:sent_notifications) do |t|
      t.references :submission, index: true, foreign_key: true
    end
    SentNotification.update_all("submission_id = subject_id")
    remove_column :sent_notifications, :subject_id
    remove_column :sent_notifications, :subject_type
  end
end
