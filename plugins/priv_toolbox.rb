# -*- coding: utf-8 -*-

module Cinch::Plugins
  class PrivToolbox
    include Cinch::Plugin

      set plugin_name: "Private toolbox",
        help: "Bot administrator-only private commands.\nUsage: n/a",
        react_on: :private,
        prefix: /^/

      def initialize(*args)
        super
        @admins = CinchStorage.new(config[:filename] || 'yaml/admins.yml')
        @admins.data ||= Array.new
      end

      match /nick (.+)/, method: :nick
      def nick(m, new_nick)
        return unless admin?(m.user, @admins.data)
        bot.nick = new_nick
      end

      match /say (#\S+) (.+)/, method: :say
      def say(m, channel, text)
        return unless admin?(m.user, @admins.data)
        Channel(channel).send(Format(:yellow, text))
        m.reply("#{Format(:yellow, "Said in #{channel}: \"#{text}\"")}", false)
        # @bot.handlers.dispatch :private_admin, m, "said in #{channel}: #{text}", m.target
      end

      match /msg (\S+) (.+)/, method: :msg
      def msg(m, user, text)
        return unless admin?(m.user, @admins.data)
        User(user).send(Format(:yellow, text))
        m.reply("#{Format(:yellow, "said to #{user}: #{text}\"")}", false)
        # @bot.handlers.dispatch :private_admin, m, "said to #{user}: #{text}", m.target
      end

      match /act (#\S+) (.+)/, method: :act
      def act(m, channel, text)
        return unless admin?(m.user, @admins.data)
        Channel(channel).action(text)
        m.reply("#{Format(:yellow, "I have acted in #{channel}: \"#{text}\"")}", false)
        # @bot.handlers.dispatch :private_admin, m, "acted in #{channel}: #{text}", m.target
      end

      match /cs (.+)/, method: :cs
      def cs(m, text)
        return unless admin?(m.user, @admins.data)
        User("chanserv").send(text)
        m.reply("#{Format(:yellow, "chanserv: \"#{text}\"")}", false)
        # @bot.handlers.dispatch :private_admin, m, "chanserv: #{text}", m.target
      end

      match /warn (#\S+) (\S+) (.+)/, method: :warn
      def warn(m, channel, user, msg)
        return unless admin?(m.user, @admins.data)
        msg ||= m.user.nick
        channel = Channel(channel)
        user = User(user)
        m.reply("#{Format(:yellow, "I have warned user #{user.nick} in #{channel}: \"#{msg}\"")}", false)
        Channel(channel).send(Format(:red, "#{user.nick.upcase}: YOU ARE BEING WARNED, REASON: #{msg.upcase}"))
      end

      # Channel kicks etc.

      match /kick (#\S+) (\S+)\s?(.+)?/, method: :kick
      def kick(m, channel, user, msg)
        return unless admin?(m.user, @admins.data)
        msg ||= m.user.nick
        channel = Channel(channel)
        user = User(user)
        channel.kick(user, msg)
        m.reply("#{Format(:yellow, "Kicked #{user.nick} from #{channel.name}#{" - \"#{msg}\"" unless msg.nil?}")}")
        m.channel.send("#{Format(:red, "GR!")}")
        # @bot.handlers.dispatch :admin, m, "Kicked #{user.nick} from #{channel.name}#{" - \"#{msg}\"" unless msg.nil?}", m.target
      end

      match /ban (#\S+) (\S+)/, method: :ban
      def ban(m, channel, user)
        return unless admin?(m.user, @admins.data)
        channel = Channel(channel)
        user = User(user)
        mask = user.mask("*!*@%h")
        channel.ban(mask)
        # @bot.handlers.dispatch :admin, m, "Banned #{user.nick} (#{mask.to_s}) from #{channel.name}", m.target
      end

      match /unban (#\S+) (\S+)/, method: :unban
      def unban(m, channel, mask)
        return unless admin?(m.user, @admins.data)
        channel = Channel(channel)
        channel.unban(mask)
        m.reply("#{Format(:yellow, "Unbanned #{mask} from #{channel.name}")}")
        # @bot.handlers.dispatch :admin, m, "Unbanned #{mask} from #{channel.name}", m.target
      end

      match /kb (#\S+) (\S+)(?: (.+))?/, method: :kickban
      def kickban(m, channel, user, msg)
        return unless admin?(m.user, @admins.data)
        msg ||= m.user.nick
        channel = Channel(channel)
        user = User(user)
        mask = user.mask("*!*@%h")
        channel.ban(mask)
        channel.kick(user, msg)
        m.reply("#{Format(:yellow, "Kickbanned #{user} (#{mask.to_s}) from #{channel.name}#{" - \"#{msg}\"" unless msg.nil?}")}")
        # @bot.handlers.dispatch :admin, m, "Kickbanned #{user} (#{mask.to_s}) from #{channel.name}#{" - \"#{msg}\"" unless msg.nil?}", m.target
      end
      
  end
end