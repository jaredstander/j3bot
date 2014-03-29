module Cinch::Plugins
  class AdminToolbox
    include Cinch::Plugin

    match(/add op \w+$/, method: :add_op)
    match(/rm op \w+$/, method: :rm_op)

    def initialize(*args)
      super
      @admins = CinchStorage.new(config[:filename] || 'yaml/admins.yml')
      @admins.data ||= Array.new
    end

    def add_op(m)
      return unless admin?(m.user, @admins.data)
      user_to_add = m.params[1].slice(8, m.params[1].length)
      if !user_exists?(User(user_to_add), m.channel)
        m.reply("#{Format(:yellow, "Error: No such user #{User(user_to_add).nick}.")}")
      elsif admin?(User(user_to_add), @admins.data)
        m.reply("#{Format(:yellow, "#{User(user_to_add).nick} is already an op.")}")
      else
        @admins.data << User(user_to_add).mask.to_s.slice!((User(user_to_add).nick.length + 1), User(user_to_add).mask.to_s.length)
        @admins.synced_save(@bot)
        m.reply("#{Format(:yellow, "#{User(user_to_add).nick} is now an op.")}")
      end
    end

    def rm_op(m)
      return unless admin?(m.user, @admin.data)
      user_to_add = m.params[1].slice(7, m.params[1].length)
      if admin?(m.user, @admin.data)
        @admins.data.delete(User(user_to_add).mask.to_s.slice!((User(user_to_add).nick.length + 1), User(user_to_add).mask.to_s.length))
        @admins.synced_save(@bot)
        m.reply("#{User(user_to_add).nick} has been removed from ops.")
      else
        m.reply("User is not a listed op.")
      end
    end

  end
end