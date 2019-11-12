# frozen_string_literal: true

require './app/lib/connect_database'
require './app/lib/i18n_settings'

class Song < ActiveRecord::Base
  has_many :scores
  belongs_to :song_group

  def self.find_or_upsert_songs_by_song_code!(song_code)
    find_by(code: song_code) || SongGroup.upsert_songs_by_song_code!(song_code) && find_by(code: song_code)
  end
end
