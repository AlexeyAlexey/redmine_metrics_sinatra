class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string  :username
      t.string  :email,    null: false, unique: true
      t.string  :password, null: false, unique: true
      t.string  :salt,     null: false
      t.timestamps
    end

    add_index :users, [:email, :salt]
  end

  def down
    drop_table :users
  end
end

