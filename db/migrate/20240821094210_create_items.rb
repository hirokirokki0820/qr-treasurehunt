class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items, id: :string do |t|
      t.string :name
      t.belongs_to :post, foreign_key: true, type: :string
      t.boolean :activated, default: true

      t.timestamps
    end
  end
end
