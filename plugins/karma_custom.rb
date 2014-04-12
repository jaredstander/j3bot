# Built using https://rubygems.org/gems/cinch-karma
# Please give credit where credit it due!

module Cinch::Plugins
  class KarmaCustom
    include Cinch::Plugin

    self.help = 'Use .karma <item> to see it\'s karma level. You can use <item>++ or <item>-- [or (something with spaces)++] to alter karma for an item'

    listen_to :channel

    match /karma (.+)/, method: :check_karma
    match /k (.+)/, method: :check_karma

    def initialize(*args)
      super
      @storage = CinchStorage.new(config[:filename] || 'yaml/karma.yml')
    end

    def listen(m)
      if m.message.match(/\S+[\+\-]{2}/)
        channel = m.channel.name

        # Scan messages for multiple karma items
        m.message.scan(/(\s|\A)(\w+|\(.+?\))(\+\+|--)(\s|\z)/).each do |karma|
          process_karma(channel, karma[1].gsub(/\(|\)/, '').downcase, karma[2])
        end

        @storage.synced_save(@bot)
      end
    end

    def check_karma(m, item)
      return if sent_via_pm?(m)

      channel = m.channel.name
      item.downcase!
      init_karma(channel, item)

      m.reply("#{Format(:yellow, "Karma for #{item} is #{@storage.data[channel][item]}")}", false)
    end

    private

    def process_karma(channel, item, operation)
      # Ensure the item's Karma has been init
      init_karma(channel, item)

      case operation
      when '++'
        @storage.data[channel][item] += 1
      when '--'
        @storage.data[channel][item] -= 1
      end
    end

    def sent_via_pm?(m)
      if m.channel.nil?
        m.reply("#{Format(:yellow, "You must use that command in the main channel.")}", false)
        return true
      end
    end

    def init_karma(channel, item = nil)
      @storage.data[channel] ||= Hash.new
      @storage.data[channel][item] ||= 0 unless item.nil?
    end
  end
end
