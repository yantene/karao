# frozen_string_literal: true

require './app/lib/i18n_settings'

module Bot
  module Feature
    module Uonfig
      def self.help(locale)
        I18n.t(
          'features.update.help.',
          locale: locale,
        )
      end

      def self.exec(cmd, argv, user, _current_time, data)
        return false unless cmd == 'update'

        month = argv.first || Date.today.strftime('%Y%m')

        begin
          if user.navi_code.nil?
            post(
              I18n.t('features.update.navi_code_is_not_set.', locale: user.locale),
              data,
            )
          elsif month.match(/^20\d\d(0[1-9]|1[0-2])$/)
            user.update_scores!(month)
            post(
              I18n.t('features.update.score_update_succeed.', locale: user.locale),
              data,
            )
          else
            post(
              I18n.t('features.update.invalid_month_specified.', locale: user.locale),
              data,
            )
          end
        rescue => e
          p e
          post(
            I18n.t('features.update.score_update_failed.', locale: user.locale),
            data,
          )
        end

        true
      end
    end
  end
end
