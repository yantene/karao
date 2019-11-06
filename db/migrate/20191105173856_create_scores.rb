class CreateScores < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|
      t.references :user, null: false
      t.references :song, null: false
      t.decimal :score, null: false, precision: 6, scale: 3, comment: 'JOYSOUND全国採点グランプリのスコア'
      t.datetime :scored_at, null: false, comment: 'playDtTm'
      t.timestamp
    end
    add_index :scores, %i[user_id scored_at], unique: true
  end
end
