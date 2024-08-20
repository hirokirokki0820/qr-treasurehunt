class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :string do |t|
      t.string :name
      t.string :password_digest
      t.string :remember_digest

      t.timestamps
    end
  end
end
