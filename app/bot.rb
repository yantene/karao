# frozen_string_literal: true

Dir.glob('./app/**/*.rb').each(&method(:require))

module Bot
  TRIGGER_COMMAND = /ysbot /.freeze

  def self.start!
    SLACK_CLIENT.on :message do |data|
      Thread.new(data) do
        next if data.text.nil?

        Slack::Messages::Formatting.unescape(data.text).each_line do |text|
          next unless text.start_with?(TRIGGER_COMMAND)

          user = User.find_or_create_by!(slack_id: data.user)
          current_time = Time.at(data.ts.to_f)
          _, cmd, *argv = text.split

          execute(cmd, argv, user, current_time, data)
        end
      end
    end

    SLACK_CLIENT.on :user_change do |data|
      # create / update users
      user = User.find_or_create_by!(slack_id: data.user.id)
      user.update!(name: data.user.profile.display_name)
    end

    SLACK_CLIENT.start!
  end

  def self.execute(cmd, argv, user, current_time, data)
    # [Bot::Feature::Help, Bot::Feature::Config, ...].any? { ... }
    Feature.constants.map(&Feature.method(:const_get)).any? { |m|
      m.exec(cmd, argv, user, current_time, data)
    } || error(cmd, user, data)
  end

  def self.error(cmd, user, data)
    post(I18n.t('basic.error.', command: cmd, locale: user.locale), data)
  end
end
