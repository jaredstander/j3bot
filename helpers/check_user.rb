module Cinch
  module Helpers

    def admin?(user, admin_list)
      admin_list.include?(user.mask.to_s.slice!((user.nick.length + 1), user.mask.to_s.length))
    end

    def bot_op?(channel)
      bot_user = channel.users.select { |user| user.nick == bot.nick }
      bot_user.first[1].include?("o") ? true : false
    end

  end
end