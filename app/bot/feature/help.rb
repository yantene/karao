# frozen_string_literal: true

require './app/lib/i18n_settings'

module Bot
  module Feature
    module Help
      def self.help(locale)
        I18n.t('features.help.help.', locale: locale)
      end

      def self.exec(cmd, _argv, user, _current_time, data)
        return false unless cmd == 'help'

        post(
          Feature.constants.map(&Feature.method(:const_get)).map { |m|
            m.help(user.locale)
          }.join("\n"),
          data,
        )

        true
      end
    end
  end
end
