require "securerandom"

module Cinch::Plugins
  class RecognizeSelf
    extend Cinch::Self
    include Cinch::Plugin

    recognize /: (.+)/, method: :recognize_self

    def recognize_self(m, message)
      m.reply(Format(:yellow, "#{m.user.nick}: #{SecureRandom.hex(message.length).slice(0, message.length)}"), false)
    end
  end
end