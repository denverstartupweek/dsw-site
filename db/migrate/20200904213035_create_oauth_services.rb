class CreateOauthServices < ActiveRecord::Migration[6.0]
  def change
    create_table :oauth_services do |t|
      t.string :uid, null: false
      t.text :description
      t.string :provider, null: false
      t.references :user, foreign_key: true
      t.string :token
      t.string :refresh_token
      t.timestamp :token_expires_at
      t.timestamps
    end
    add_index :oauth_services, [:provider, :uid], unique: true
  end
end
