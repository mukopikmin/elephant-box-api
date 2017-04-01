class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.boolean :admin, null: false, default: false
      t.boolean :removed, null: false, default: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
