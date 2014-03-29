module Cinch::Plugins
  class Spike
    extend Cinch::Self
    include Cinch::Plugin

    recognize /: (.+)/

    def execute(m, message)
      m.reply(Format(:yellow, "#{m.user.nick}: #{SecureRandom.hex(message.length)}"), false)
    end
  end
end