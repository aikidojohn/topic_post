class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content
      t.string :user
      t.integer :topic_id

      t.timestamps
    end
  end
end
