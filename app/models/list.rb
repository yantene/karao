# frozen_string_literal: true

require './app/lib/connect_database'
require './app/lib/i18n_settings'

class List < ActiveRecord::Base
  validates :name, format: { with: /\w+/ }

  belongs_to :user
  has_many :song_groups_lists, dependent: :destroy
  has_many :song_groups, through: :song_groups_lists

  def add(*song_codes)
    songs = song_codes.map(&Song.method(:find_or_upsert_songs_by_song_code!))

    return false if songs.any?(&:nil?)

    song_groups << songs.map(&:song_group)
  end

  def remove(*song_codes)
    songs = song_codes.map(&Song.method(:find_or_upsert_songs_by_song_code!))

    return false if songs.any?(&:nil?)

    song_groups.delete(*songs.map(&:song_group))
  end
end
