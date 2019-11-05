class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.string :code, null: false, comment: 'naviGroupId'
      t.string :title, null: false, comment: 'songName'
      t.string :artist, null: false, comment: 'artistName'
      t.timestamp
    end
    add_index :songs, :code, unique: true
  end
end
