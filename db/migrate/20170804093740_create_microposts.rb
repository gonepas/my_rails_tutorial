class CreateMicroposts < ActiveRecord::Migration[5.0]
  def change
    create_table :microposts do |table|
      table.text :content
      table.references :user, foreign_key: true

      table.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
  end
end
