# frozen_string_literal: true

require './app/lib/connect_database'
require './app/lib/i18n_settings'

class List < ActiveRecord::Base
  validates :name, format: { with: /\w+/ }

  belongs_to :user
  has_many :song_groups_lists
  has_many :song_groups, through: :song_groups_lists
end
