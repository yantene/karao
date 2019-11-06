class CreateSongGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :song_groups do |t|
      t.integer :code, null: false, comment: 'naviGroupId'
      t.string :title, null: false, comment: 'songName'
      t.string :artist, null: false, comment: 'artistName'
      t.timestamp
    end
    add_index :song_groups, :code, unique: true
  end
end
