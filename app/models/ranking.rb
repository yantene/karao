# frozen_string_literal: true

require './app/lib/connect_database'
require './app/lib/i18n_settings'
require 'net/http'
require 'json'

class Ranking < ActiveRecord::Base
  belongs_to :song

  scope :latest, -> { where(latest: true) }

  def self.update_ranking!
    ActiveRecord::Base.transaction do
      Ranking.update_all(latest: false)

      ranking_data = fetch_ranking

      logged_at = ranking_data['updateDate']
          .match(/(?<y>\d{4})(?<m>\d{2})(?<d>\d{2})(?<h>\d{2})(?<m>\d{2})(?<s>\d{2})/).then { |m|
        Time.new(*m.values_at(:y, :m, :d, :h, :m, :s), '+09:00')
      }
      ranking_data['genreRankingList'].each do |song_data|
        song = Song.find_or_create_by!(code: song_data['naviGroupId']) { |song|
          song.title = song_data['songName']
          song.artist = song_data['artistName']
        }

        song.rankings.create!(rank: song_data['currRank'], logged_at: logged_at)
      end
    end
  end

  DEFAULT_PARAMS = {
    kind: 'all',
    period: 'monthly', # 'daily', 'weekly', 'monthly'
    start: 1,
    count: 100,
    endRank: 100,
    appId: '0000800',
  }

  def self.fetch_ranking(params = {})
    response = Net::HTTP.post(
      URI.parse('https://www.joysound.com/web/api/1.0/karaoke/songranking'),
      URI.encode_www_form(DEFAULT_PARAMS),
      'Accept': 'application/json',
      'X-JPT': 'joysoundPortal',
      'Content-Type': 'application/x-www-form-urlencoded',
    )

    JSON.parse(response.body)
  end
end
