class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content
      t.integer :topic_id
      t.integer :user_id

      t.timestamps
    end
    add_index :posts, [:topic_id, :created_at]
  end
end
