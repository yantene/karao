# frozen_string_literal: true

require './app/lib/i18n_settings'

module Bot
  module Feature
    module Score
      def self.help(locale)
        I18n.t(
          'features.score.help.',
          available_locales: I18n.available_locales.join(', '),
          locale: locale,
        )
      end

      def self.exec(cmd, argv, user, _current_time, data)
        return false unless cmd == 'score'

        code, value = argv.take(2)

        song = Song.find_by!(code: code)

        score = ::Score.find_or_initialize_by(user_id: user.id, song_id: song.id)
        score.update!(score: value)

        post(
          I18n.t('features.score.score_updated.', locale: user.locale),
          data,
        )

        true
      rescue ActiveRecord::RecordInvalid => e
        post(e.message, data)

        true
      end
    end
  end
end
