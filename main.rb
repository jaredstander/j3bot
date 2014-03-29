# Main file for the IRC bot.

# Require cinch to use the cinch IRC bot framework
require "cinch"
require "open-uri"
require "nokogiri"
require "securerandom"
require_relative "helpers/check_user"
require_relative "helpers/self"
require_relative "plugins/admin_toolbox"
require_relative "plugins/auto_op"
require_relative "plugins/dice_custom"
require_relative "plugins/haiku_custom"
require_relative "plugins/karma_custom"
require_relative "plugins/priv_toolbox"
require_relative "plugins/set_topic"
require_relative "plugins/show_url_title"
require_relative "plugins/spike"

# Instantiate a new bot
bot = Cinch::Bot.new do
  configure do |c|
    # set configuration options
    c.verbose
    c.realname = "Metal Child"
    c.nick     = "j3bot"
    c.server   = ""
    c.channels = [""]
    c.plugins.plugins = [Cinch::Plugins::AdminToolbox,
                         Cinch::Plugins::AutoOP,
                         Cinch::Plugins::DiceRollCustom,
                         Cinch::Plugins::HaikuCustom,
                         Cinch::Plugins::KarmaCustom,
                         Cinch::Plugins::PrivToolbox,
                         Cinch::Plugins::SetTopic,
                         Cinch::Plugins::ShowURLTitle,
                         Cinch::Plugins::Spike]
    c.plugins.options[Cinch::Plugins::HaikuCustom] = {:delay => 1}
    c.shared[:cooldown] = { :config => { '#totaltest' => { :global => 1, :user => 20 } } }
  end

  # Welcome new users when they join a channel with a sample of welcome messages.
  on :join do |m|
    unless m.user.nick == bot.nick
      m.reply("#{m.user.nick}: #{Format(:yellow, ["Willkommen!", "Halo!", "Halo Reach!", "We are well met."].sample)}", false)
    end
  end
end

bot.start

# Things I want my IRC bot to do:
# => Add weather plugin
# => (Tabled) Flood warning / Kicking ===> Need to work out plugin config.
# => Easter Eggs