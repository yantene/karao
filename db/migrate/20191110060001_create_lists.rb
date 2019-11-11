class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :name, null: false, comment: 'name of list'
      t.boolean :locked, null: false, default: false
      t.references :user, foreign_key: true
      t.timestamps
    end
    add_index :lists, :name, unique: true
  end
end
