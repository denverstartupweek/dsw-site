class AddFuzzyIndicesForUserSearch < ActiveRecord::Migration[6.0]
  def change
    add_index :companies, :name, using: :gist, opclass: :gist_trgm_ops, name: "idx_companies_name_contains_gist"
    add_index :users, :name, using: :gist, opclass: :gist_trgm_ops, name: "idx_users_name_contains_gist"
    add_index :users, :email, using: :gist, opclass: :gist_trgm_ops, name: "idx_users_email_contains_gist"
    add_index :submissions, :title, using: :gist, opclass: :gist_trgm_ops, name: "idx_submissions_title_contains_gist"
    add_index :submissions, :description, using: :gist, opclass: :gist_trgm_ops, name: "idx_submissions_description_contains_gist"
  end
end
