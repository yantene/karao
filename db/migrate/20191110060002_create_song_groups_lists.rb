class CreateSongGroupsLists < ActiveRecord::Migration[5.2]
  def change
    create_table :song_groups_lists do |t|
      t.references :list, null: false
      t.references :song_group, null: false
      t.references :user, foreign_key: true
      t.timestamps
    end
    add_index :song_groups_lists, %i[list_id song_group_id], unique: true
  end
end
