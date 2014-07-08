module Cinch::Plugins
  class SetTopic
    include Cinch::Plugin

    match /topic (.+)/, method: :set_topic
    match /add topic (.+)/, method: :add_topic

    def initialize(*args)
      super
      @admins = CinchStorage.new(config[:filename] || 'yaml/admins.yml')
      @admins.data ||= Array.new
    end

    def set_topic(m, topic)
      if bot_op?(m.channel)
        m.channel.topic = topic
      else
        m.reply("#{Format(:yellow, "#{m.user.nick}: Cannot comply, I am not an operator.")}", false)
      end
    end

    def add_topic(m, topic)
      if bot_op?(m.channel)
        m.channel.topic = m.channel.topic + " | " + topic
      else
        m.reply("#{Format(:yellow, "#{m.user.nick}: Cannot comply, I am not an operator.")}", false)
      end
    end
  end
end