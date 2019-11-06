# frozen_string_literal: true

require './app/lib/connect_database'
require './app/lib/i18n_settings'

# Slack ユーザに対応するクラス
class User < ActiveRecord::Base
  validates :locale, inclusion: { in: I18n.available_locales.map(&:to_s) }
  validates :joysound_code, format: { with: /[0-9a-fA-F]{36}/ }

  has_many :scores

  def update_scores!(month = (Date.today - 1).strftime('%Y%m'))
    User.fetch_scores(joysound_code, (Date.today - 1).strftime('%Y%m')).each do |score_info|
      song = Song.find_or_create_by!(code: score_info['selSongNo'], title: score_info['selSongName'], artist: score_info['artistName'])

      scores.find_or_create_by!(song_id: song.id, score: score_info['markNum'], scored_at: Time.at(score_info['playDtTm'] / 1000))
    end
  end

  def self.fetch_scores(joysound_code, month)
    scores = []
    start_index = 0

    loop do
      json = fetch_score_json(joysound_code, startIndex: start_index, count: 200, selectMonth: month, maxPageNum: 1)
      scores.append(*json['gpHistories'])

      break unless json['pager']['isNext']

      start_index = json['pager']['nextOffset']
      sleep 1
    end

    scores
  end

  def self.fetch_score_json(joysound_code, params)
    uri = URI.parse("https://www.joysound.com/api/1.0/member/#{joysound_code}/score/gpHistory/user")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http|
      http.get(
        "#{uri.path}?#{URI.encode_www_form(params)}",
        'Accept': 'application/json',
        'X-JSP-APP-NAME': 'www.joysound.com',
      )
    }

    JSON.parse(res.body)
  end

  def self.update_user_name!
    SLACK_CLIENT.web_client.users_list['members'].each do |user_data|
      name = user_data['profile'].then { |pr| pr['display_name'].empty? ? pr['real_name'] : pr['display_name'] }
      user = User.find_by(slack_id: user_data['id'])
      user&.update!(name: name)
    end
  end
end
