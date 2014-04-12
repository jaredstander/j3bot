require "cinch-storage"

module Cinch::Plugins
  class AdminListControl
    include Cinch::Plugin

    match /add op (\w+$)/, method: :add_op
    match /rm op (\w+$)/, method: :rm_op

    def initialize(*args)
      super
      @admins = CinchStorage.new(config[:filename] || 'yaml/admins.yml')
      @admins.data ||= Array.new
    end

    def add_op(m, user_to_add)
      return unless admin?(m.user, @admins.data)
      if !user_exists?(User(user_to_add), m.channel)
        m.reply("#{Format(:yellow, "Error: No such user #{User(user_to_add).nick}.")}")
      elsif admin?(User(user_to_add), @admins.data)
        m.reply("#{Format(:yellow, "#{User(user_to_add).nick} is already an op.")}")
      else
        @admins.data << User(user_to_add).mask.to_s.slice!((User(user_to_add).nick.length + 1), User(user_to_add).mask.to_s.length)
        @admins.synced_save(@bot)
        m.reply("#{Format(:yellow, "#{User(user_to_add).nick} is now an op.")}")
        m.channel.op(User(user_to_add)) unless m.channel.opped?(User(user_to_add))
        if !bot_op?(m.channel) && !m.channel.opped?(User(user_to_add))
          m.reply("#{Format(:yellow, "Warning: Automatic op of #{user_to_add} failed, I am not a channel operator.")}")
        end
      end
    end

    def rm_op(m, user_to_remove)
      return unless admin?(m.user, @admins.data)
      if !user_exists?(User(user_to_remove), m.channel)
        m.reply("#{Format(:yellow, "Error: No such user #{User(user_to_remove).nick}.")}")
      elsif admin?(m.user, @admins.data)
        @admins.data.delete(User(user_to_remove).mask.to_s.slice!((User(user_to_remove).nick.length + 1), User(user_to_remove).mask.to_s.length))
        @admins.synced_save(@bot)
        m.reply("#{Format(:yellow, "#{User(user_to_remove).nick} has been removed from ops.")}")
        m.channel.deop(User(user_to_remove)) unless !m.channel.opped?(User(user_to_remove))
        if !bot_op?(m.channel) && m.channel.opped?(User(user_to_remove))
          m.reply("#{Format(:yellow, "Warning: Automatic op of #{user_to_remove} failed, I am not a channel operator.")}")
        end
      else
        m.reply("#{Format(:yellow, "#{User(user_to_remove).nick} is not a listed op.")}")
      end
    end

  end
end