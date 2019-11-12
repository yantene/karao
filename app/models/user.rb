# frozen_string_literal: true

require './app/lib/connect_database'
require './app/lib/i18n_settings'

# Slack ユーザに対応するクラス
class User < ActiveRecord::Base
  validates :locale, inclusion: { in: I18n.available_locales.map(&:to_s) }
  validates :navi_code, format: { with: /[0-9a-fA-F]{36}/ }, allow_nil: true

  has_many :scores
  has_many :lists
  has_many :song_groups_lists

  def update_scores!(month = (Date.today - 1).strftime('%Y%m'))
    ActiveRecord::Base.transaction do
      Score.fetch_scores(navi_code, month).each do |score_info|
        song = Song.find_or_upsert_songs_by_song_code!(score_info['selSongNo'])

        scores.find_or_create_by!(song_id: song.id, score: score_info['markNum'], scored_at: Time.at(score_info['playDtTm'] / 1000))
      end
    end
  end

  def self.update_user_name!
    SLACK_CLIENT.web_client.users_list['members'].each do |user_data|
      name = user_data['profile'].then { |pr| pr['display_name'].empty? ? pr['real_name'] : pr['display_name'] }
      user = User.find_by(slack_id: user_data['id'])
      user&.update!(name: name)
    end
  end
end
