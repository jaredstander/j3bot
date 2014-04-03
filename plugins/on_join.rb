module Cinch::Plugins
  class OnJoin
    include Cinch::Plugin

    listen_to :join, :method => :on_join

    def initialize(*args)
      super
      @auto_op = false
      @admins = CinchStorage.new(config[:filename] || 'yaml/admins.yml')
      @admins.data ||= Array.new
    end

    def on_join(m)
      unless m.user.nick == bot.nick
        if admin?(m.user, @admins.data)
          Channel(m.channel).action("bows")
          if bot_op?(m.channel)
            m.reply("#{Format(:yellow, "May the flames guide thee, #{m.user.nick}.")}", false)
            m.channel.op(m.user)
          else
            m.reply("#{Format(:yellow, "May the flames guide thee, #{m.user.nick}. Unfortunately, I am not an operator, and cannot authorize on join at this time.")}")
          end
        else
          m.reply("#{Format(:yellow, "#{m.user.nick}: " + ["Willkommen!", "Halo!", "Halo Reach!", "We are well met.", "Hello.", "Welcome back maybe!", "Hey dood.", "Sup."].sample)}", false)
        end
      end
    end

  end
end