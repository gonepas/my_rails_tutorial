class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |table|
      table.string :name
      table.string :email

      table.timestamps
    end
  end
end
