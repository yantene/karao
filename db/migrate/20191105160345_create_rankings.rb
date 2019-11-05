class CreateRankings < ActiveRecord::Migration[5.2]
  def change
    create_table :rankings do |t|
      t.references :song, null: false
      t.integer :rank, null: false, comment: 'currRank'
      t.datetime :logged_at, null: false, comment: 'updateDate'
      t.boolean :latest, null: false, default: true
    end
    add_index :rankings, %i[logged_at rank], unique: true
  end
end
