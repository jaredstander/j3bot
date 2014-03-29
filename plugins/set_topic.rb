module Cinch::Plugins
  class SetTopic
    include Cinch::Plugin

    match /topic (.+)/, method: :set_topic

    def initialize(*args)
      super
      @auto_op = false
      @admins = CinchStorage.new(config[:filename] || 'yaml/admins.yml')
      @admins.data ||= Array.new
    end

    def set_topic(m, topic)
      return unless admin?(m.user, @admins.data)
      if bot_op?(m.channel)
        m.channel.topic = topic
      else
        m.reply("#{Format(:yellow, "Cannot comply, I am not an operator.")}", true)
      end
    end
  end
end