# frozen_string_literal: true

require './app/lib/i18n_settings'

module Bot
  module Feature
    module List
      def self.help(locale)
        I18n.t(
          'features.list.help.',
          locale: locale,
        )
      end

      def self.exec(cmd, argv, user, _current_time, data)
        return false unless cmd == 'list'

        subcmd = argv.shift

        if argv.empty?
          post(
            ::List.joins(:user).pluck(:name, 'users.name').map { |name, user| "- *#{name}* by #{user}" }.join("\n"),
            data,
          )
          return true
        end

        list_name = argv.shift

        unless list_name.match(/\w+/)
          post(
            I18n.t('features.list.invalid_list_name.', locale: user.locale),
            data,
          )
          return true
        end

        if 'create' == subcmd # リストを新規作成
          user.lists.create!(name: list_name)
          post(I18n.t('features.list.list_created.', list_name: list_name, locale: user.locale), data)
          return true
        end

        # リストが存在していなくても行える操作はここまで
        unless list = user.lists.find_by(name: list_name)
          post(I18n.t('features.list.list_not_found.', list_name: list_name, locale: user.locale), data)
          return true
        end

        case subcmd
        when 'show' # リストの曲を表示
          post(show(list, user), data)
          return true
        when 'lock' # リストをロック
          list.update!(locked: true)
          post(I18n.t('features.list.lock_list.', list_name: list_name, locale: user.locale), data)
          return true
        when 'unlock' # リストをアンロック
          list.update!(locked: false)
          post(I18n.t('features.list.unlock_list.', list_name: list_name, locale: user.locale), data)
          return true
        end

        # リストがロックされていてもできる操作はここまで
        if list.locked?
          post(I18n.t('features.list.list_locked.', list_name: list_name, locale: user.locale), data)
          return true
        end

        if subcmd == 'delete' # リスト削除
          list.destroy!
          post(I18n.t('features.list.list_deleted.', list_name: list_name, locale: user.locale), data)
          return true
        end

        song_codes = argv
        case subcmd
        when 'add' # リストに曲追加
          if list.add(*song_codes)
            post(I18n.t('features.list.add_succeed.', list_name: list_name, locale: user.locale), data)
          else
            post(I18n.t('features.list.add_failed.', list_name: list_name, locale: user.locale), data)
          end
        when 'remove' # リストから曲を削除
          if list.remove(*song_codes)
            post(I18n.t('features.list.remove_succeed.', list_name: list_name, locale: user.locale), data)
          else
            post(I18n.t('features.list.remove_failed.', list_name: list_name, locale: user.locale), data)
          end
        else
        end

        true
      end

      def self.show(list, user)
        scores = list.song_groups
          .left_joins(songs: :scores)
          .merge(Score.where(user_id: user.id))
          .group('song_groups.id')
          .pluck('song_groups.id', Arel.sql('MAX(scores.score)')).to_h

        [
          ":memo: *#{list.name}* by #{list.user.name} :#{list.locked? ? 'lock' : 'unlock' }:",
          list.song_groups
              .order('song_groups_lists.id')
              .pluck(:id, :title, :artist)
              .map.with_index(1) { |(song_group_id, title, artist), index|
            scores[song_group_id].then { |score|
              [
                "#{'%3d' % index}.",
                "*#{title}*",
                artist,
                [
                  case score
                  when 85...90
                    ':third_place_medal:'
                  when 90...96
                    ':second_place_medal:'
                  when 96..100
                    ':first_place_medal:'
                  end,
                  "#{'%3.3d' % score} pts"
                ].join.then { |evl| evl unless score.nil? },
              ].join(' ')
            }
          }.join("\n"),
        ].join("\n\n")
      end
    end
  end
end
