class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |table|
      table.integer :follower_id
      table.integer :followed_id
      table.timestamps
    end
    indexx
  end

  private
    def indexx
      add_index :relationships, :follower_id
      add_index :relationships, :followed_id
      add_index :relationships, [:follower_id, :followed_id], unique: true
    end
end
