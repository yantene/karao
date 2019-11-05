# frozen_string_literal: true

require './app/lib/connect_database'
require './app/lib/i18n_settings'

class Score < ActiveRecord::Base
  validates :score, format: { with: /\d{1,3}(\.\d{1,3})?/ }, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  belongs_to :song
  belongs_to :user
end
