# frozen_string_literal: true

require './app/lib/i18n_settings'

module Bot
  module Feature
    module Config
      def self.help(locale)
        I18n.t(
          'features.config.help.',
          available_locales: I18n.available_locales.join(', '),
          locale: locale,
        )
      end

      def self.exec(cmd, argv, user, _current_time, data)
        return false unless cmd == 'config'

        subcmd, val = argv.take(2)

        case subcmd
        when 'locale'
          if val.nil?
            check_locale(user, data)
          else
            locale(val, user, data)
          end
        when 'joysound'
          if val.nil?
            check_joysound_code(user, data)
          else
            joysound_code(val, user, data)
          end
        else
          if subcmd.nil?
            post(
              I18n.t('features.config.subcmd_not_given.', locale: user.locale),
              data,
            )
          else
            post(
              I18n.t('features.config.subcmd_not_found.', subcommand: subcmd, locale: user.locale),
              data,
            )
          end
        end

        true
      end

      def self.check_locale(user, data)
        post(
          I18n.t(
            'features.config.check_locale.',
            current_locale: user.locale,
            locale: user.locale,
          ),
          data,
        )
      end

      def self.locale(val, user, data)
        user.update!(locale: val)

        post(
          I18n.t(
            'features.config.locale_changed.',
            set_locale: val,
            locale: user.locale,
          ),
          data,
        )
      rescue ActiveRecord::RecordInvalid
        post(
          I18n.t(
            'features.config.unavailable_locale.',
            set_locale: val,
            locale: user.locale_before_last_save,
          ),
          data,
        )
      end

      def self.check_joysound_code(user, data)
        post(
          I18n.t(
            'features.config.check_joysound_code.',
            current_joysound_code: user.joysound_code,
            locale: user.locale,
          ),
          data,
        )
      end

      def self.joysound_code(val, user, data)
        user.update!(joysound_code: val)

        post(
          I18n.t(
            'features.config.joysound_code_changed.',
            set_joysound_code: val,
            locale: user.locale,
          ),
          data,
        )
      rescue ActiveRecord::RecordInvalid
        post(
          I18n.t(
            'features.config.invalid_joysound_code.',
            set_joysound_code: val,
            locale: user.locale,
          ),
          data,
        )
      end
    end
  end
end
