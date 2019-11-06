# frozen_string_literal: true

require './app/lib/connect_database'
require './app/lib/i18n_settings'

class Score < ActiveRecord::Base
  validates :score, format: { with: /\d{1,3}(\.\d{1,3})?/ }, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  belongs_to :song
  belongs_to :user

  def self.fetch_scores(navi_code, month)
    scores = []
    start_index = 0

    loop do
      json = fetch_gp_history_json(navi_code, startIndex: start_index, count: 200, selectMonth: month, maxPageNum: 1)
      scores.append(*json['gpHistories'])

      break unless json['pager']['isNext']

      start_index = json['pager']['nextOffset']
      sleep 1
    end

    scores
  end

  def self.fetch_gp_history_json(navi_code, params)
    uri = URI.parse("https://www.joysound.com/api/1.0/member/#{navi_code}/score/gpHistory/user")
    sleep [0, 1 - (Time.now - $last_fetched_at)].max unless $last_fetched_at.nil?
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http|
      http.get(
        "#{uri.path}?#{URI.encode_www_form(params)}",
        'Accept': 'application/json',
        'X-JSP-APP-NAME': 'www.joysound.com',
      )
    }
    $last_fetched_at = Time.now

    JSON.parse(res.body)
  end
end
