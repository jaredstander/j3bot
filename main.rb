# Main file for the IRC bot.

# Require cinch to use the cinch IRC bot framework
require "cinch"
require_relative "helpers/check_user"
require_relative "helpers/self"
require_relative "plugins/admin_list_control"
require_relative "plugins/define"
require_relative "plugins/dice_custom"
require_relative "plugins/haiku_custom"
require_relative "plugins/help"
require_relative "plugins/karma_custom"
require_relative "plugins/on_join"
require_relative "plugins/priv_toolbox"
require_relative "plugins/recognize_self"
require_relative "plugins/set_topic"
require_relative "plugins/show_url_title"

# Instantiate a new bot
bot = Cinch::Bot.new do
  configure do |c|
    # set configuration options
    c.verbose
    c.realname = "Metal Child"
    c.nick     = "j3bot"
    c.server   = "irc.wherestheparty.at"
    c.channels = ["#poopsock"]
    c.plugins.plugins = [Cinch::Plugins::AdminListControl,
                         Cinch::Plugins::Define,
                         Cinch::Plugins::DiceRollCustom,
                         Cinch::Plugins::HaikuCustom,
                         Cinch::Plugins::Help,
                         Cinch::Plugins::KarmaCustom,
                         Cinch::Plugins::OnJoin,
                         Cinch::Plugins::PrivToolbox,
                         Cinch::Plugins::RecognizeSelf,
                         Cinch::Plugins::SetTopic,
                         Cinch::Plugins::ShowURLTitle]
    c.plugins.options[Cinch::Plugins::HaikuCustom] = {:delay => 1}
  end

  on :leaving do |m|
    chance = (rand(1000) + 1)
    if chance == 1000
      m.reply("#{Format(:yellow, "Srsly though, #{m.user.nick} is such a jerk.")}", false)
    end
  end
end

bot.start