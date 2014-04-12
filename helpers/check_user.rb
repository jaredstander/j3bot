module Cinch
  module Helpers

    def admin?(user, admin_list)
      puts " "
      puts " "
      puts admin_list
      puts user.mask
      puts user.nick
      puts user.mask.to_s.slice!((user.nick.length + 1), user.mask.to_s.length)
      puts " "
      puts " "
      admin_list.include?(user.mask.to_s.slice!((user.nick.length + 1), user.mask.to_s.length))
    end

    def bot_op?(channel)
      bot_user = channel.users.select { |user| user.nick == bot.nick }
      bot_user.first[1].include?("o") ? true : false
    end

    def other_ops?(channel)
      other_ops = false
      channel.users.each do |user|
        unless user[1] == bot.nick
          user[1].include?("o") ? other_ops = true : other_ops = false
        end
      end
      other_ops
    end

    def user_exists?(user, channel)
      channel.users.include?(user)
    end

  end
end