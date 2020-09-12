class CreateJobFairSignupTimeSlots < ActiveRecord::Migration[6.0]
  def change
    create_table :job_fair_signup_time_slots do |t|
      t.references :job_fair_signup, null: false, foreign_key: true
      t.references :submission, null: false, foreign_key: true

      t.timestamps
    end
  end
end
