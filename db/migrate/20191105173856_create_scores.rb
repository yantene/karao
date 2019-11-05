class CreateScores < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|
      t.references :user, null: false
      t.references :song, null: false
      t.decimal :score, precision: 6, scale: 3, comment: 'JOYSOUND の分析採点マスターのスコア'
      t.timestamp
    end

    add_index :scores, %i[user_id song_id], unique: true
  end
end
