# Main file for the IRC bot.

# Require cinch to use the cinch IRC bot framework
require "cinch"
require "open-uri"
require "nokogiri"
require "securerandom"
require_relative "helpers/check_user"
require_relative "helpers/self"
require_relative "plugins/admin_list_control"
require_relative "plugins/dice_custom"
require_relative "plugins/haiku_custom"
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
    c.server   = "localhost"
    c.channels = ["#testchannel"]
    c.plugins.plugins = [Cinch::Plugins::AdminListControl,
                         Cinch::Plugins::DiceRollCustom,
                         Cinch::Plugins::HaikuCustom,
                         Cinch::Plugins::KarmaCustom,
                         Cinch::Plugins::OnJoin,
                         Cinch::Plugins::PrivToolbox,
                         Cinch::Plugins::RecognizeSelf,
                         Cinch::Plugins::SetTopic,
                         Cinch::Plugins::ShowURLTitle]
    c.plugins.options[Cinch::Plugins::HaikuCustom] = {:delay => 1}
    c.shared[:cooldown] = { :config => { '#testchannel' => { :global => 1, :user => 20 } } }
  end
end

bot.start