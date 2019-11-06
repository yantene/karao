class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.integer :code, null: false, comment: 'songId (selSongNo)'
      t.string :title, null: false, comment: 'songName'
      t.references :song_group
      t.timestamp
    end
    add_index :songs, :code, unique: true
  end
end
