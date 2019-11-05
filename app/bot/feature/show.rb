# frozen_string_literal: true

require './app/lib/i18n_settings'

module Bot
  module Feature
    module Show
      def self.help(locale)
        I18n.t(
          'features.show.help.',
          available_locales: I18n.available_locales.join(', '),
          locale: locale,
        )
      end

      def self.exec(cmd, argv, user, _current_time, data)
        return false unless cmd == 'show'

        subcmd, val = argv.take(2)

        case subcmd
        when 'songs'
          post(<<~EOS, data)
            ```
            #{
              Ranking.latest.order(rank: :asc).left_joins(song: :scores).limit(val || 10)
                  .pluck(:rank, :title, :artist, :code, :score).map { |rank, title, artist, code, score|
                "#{'%3d' % rank}. #{title} #{artist} (#{code})   #{score}"
              }.join("\n")
            }
            ```
          EOS
        else
          if subcmd.nil?
            post(
              I18n.t('features.show.subcmd_not_given.', locale: user.locale),
              data,
            )
          else
            post(
              I18n.t('features.show.subcmd_not_found.', subcommand: subcmd, locale: user.locale),
              data,
            )
          end
        end

        true
      end
    end
  end
end
