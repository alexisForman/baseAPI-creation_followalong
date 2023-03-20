class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      #email, first_name, last_name, phone, :password_digest
      t.string :email, null: false, unique: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone, null: false, unique: true
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
