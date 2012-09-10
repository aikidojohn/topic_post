class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :twitter_image
      t.string :oauth_token
      t.string :oauth_token_secret

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
