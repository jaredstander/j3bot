module Cinch::Plugins
  class Help
    include Cinch::Plugin

    match /(help (.+)|help)/, method: :help

    def help(m, topic)
      if topic.length > 4
        help_topics = { "admin" => "Use \"!add op <username>\" to add a user as a bot admin and chan operator. Only existing admins can add and remove users.",
                        "define" => "Use \"!define <word>\" for a simple definition of the word. Please note, not every single definition of a word will be listed and long definitions may be truncated.",
                        "dice" => "Use \"!roll <number of dice to roll>d<sides of each die>\" to see a roll result.",
                        "haiku" => "Use \"!haiku\" to see a haiku.",
                        "karma" => "Use \"!<subject>++\" or \"!<subject>--\" to increase or decrease the karma of a subject. Use \"!karma <subject>\" to see that subject's current karma score.",
                        "topic" => "Use \"!topic <topic text>\" to set the topic. Use \"!add topic <topic text>\" to add a topic to the current one." }
        m.reply("#{Format(:yellow, "#{m.user.nick}: #{help_topics[topic.split(' ').last]}")}", false)
      else
        m.reply("#{Format(:yellow, "#{m.user.nick}: Use \"!help <topic>\" for more information. Available help topics are admin, define, dice, haiku, karma, and topic.")}", false)
      end
    end

  end
end