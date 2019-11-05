# frozen_string_literal: true

require './app/lib/connect_database'
require './app/lib/i18n_settings'

class Song < ActiveRecord::Base
  has_many :rankings
  has_many :scores
end
