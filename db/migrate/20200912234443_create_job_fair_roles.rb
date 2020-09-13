class CreateJobFairRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :job_fair_roles do |t|
      t.text :title, null: false
      t.text :description, null: false
      t.text :url, null: false
      t.references :job_fair_signup, null: false, foreign_key: true

      t.timestamps
    end
  end
end
