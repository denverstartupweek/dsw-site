class AddIsVirtualJobFairSlotToSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :submissions, :is_virtual_job_fair_slot, :boolean, default: false, null: false
  end
end
