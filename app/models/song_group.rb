# frozen_string_literal: true

require './app/lib/connect_database'
require './app/lib/i18n_settings'

class SongGroup < ActiveRecord::Base
  has_many :songs
  has_many :song_groups_lists
  has_many :lists, through: :song_groups_lists

  def self.upsert_songs_by_song_id!(song_id)
    navi_group_id = fetch_navi_group_id_by_song_id(song_id)
    upsert_songs_by_navi_group_id!(navi_group_id)
  end

  def self.upsert_songs_by_navi_group_id!(navi_group_id)
    upsert_songs!(selSongNo: navi_group_id)
  end

  def self.upsert_songs!(params)
    info = fetch_contents_detail_json(params)

    song_group = find_or_initialize_by(code: info['naviGroupId'])
    song_group.update!(
      title: info['songName'],
      artist: info['artistInfo']['artistName'],
    )

    info['aplList'].each do |apl_info|
      apl_info['selectionList'].each do |song_info|
        song = song_group.songs.find_or_initialize_by(code: song_info['selSongNo'])
        song.update!(title: song_info['songName'])
      end
    end
  end

  # 一見 selSongNo を kind に指定するとその曲の情報が取れるように見えるが、
  # apl_info の中身がめちゃくちゃだったりする。
  # 本メソッドでその曲に対応する naviGroupId を取得した上で再度取得し直す必要あり。
  def self.fetch_navi_group_id_by_song_id(song_id)
    info = fetch_contents_detail_json(kind: 'selSongNo', selSongNo: song_id)
    info['naviGroupId']
  end

  def self.fetch_contents_detail_json(params)
    sleep [0, 1 - (Time.now - $last_fetched_at)].max unless $last_fetched_at.nil?
    res = Net::HTTP.post(
      URI.parse("https://mspxy.joysound.com/Common/ContentsDetail"),
      URI.encode_www_form({ kind: 'naviGroupId', interactionFlg: 0, apiVer: 1.0 }.merge(params)),
      'Accept': 'application/json',
      'X-JSP-APP-NAME': '0000800',
      'Content-Type': 'application/x-www-form-urlencoded',
    )
    $last_fetched_at = Time.now
    JSON.parse(res.body)
  end
end
