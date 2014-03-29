module Cinch::Plugins
  class AutoOP
    include Cinch::Plugin
    attr_reader :auto_op

    match(/auto op on/, method: :auto_on)
    match(/auto op off/, method: :auto_off)

    def initialize(*args)
      super
      @auto_op = false
      @admins = CinchStorage.new(config[:filename] || 'yaml/admins.yml')
      @admins.data ||= Array.new
    end

    def auto_on(m)
      return unless admin?(m.user, @admins.data)
      if bot_op?(m.channel)
        m.reply("#{Format(:yellow, "Auto op is")} #{Format(:lime, "on")}#{Format(:yellow, ".")}", false)
        @auto_op = true
        op_check(m.channel)
      else
        m.reply("#{Format(:yellow, "#{m.user.nick}: Cannot comply, I am not an operator.")}", false)
      end
    end

    def auto_off(m)
      return unless admin?(m.user, @admins.data)
      m.reply("#{Format(:yellow, "Auto op is")} #{Format(:red, "off")}#{Format(:yellow, ".")}", false)
      @auto_op = false
    end

    def op_check(channel)
      return if !bot_op?(channel)
      while @auto_op == true
        channel.users.each do |user|
          unless user[0].nick == bot.nick
            if admin?(user[0], @admins.data) && !user[1].include?("o")
              channel.op(user[0])
            end
          end
        end

        sleep 300
      end
    end

  end
end