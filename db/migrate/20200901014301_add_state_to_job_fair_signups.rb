class AddStateToJobFairSignups < ActiveRecord::Migration[6.0]
  def change
    add_column :job_fair_signups, :state, :text, default: "created", null: false
  end
end
