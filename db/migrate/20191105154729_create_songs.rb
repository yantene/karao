class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.integer :code, null: false, comment: 'selSongNo'
      t.string :title, null: false, comment: 'selSongName'
      t.string :artist, null: false, comment: 'artistName'
      t.timestamp
    end
    add_index :songs, :code, unique: true
  end
end
