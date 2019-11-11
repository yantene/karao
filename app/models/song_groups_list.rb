# frozen_string_literal: true

require './app/lib/connect_database'
require './app/lib/i18n_settings'

class SongGroupsList < ActiveRecord::Base
  belongs_to :song_group
  belongs_to :list
end
