module Cinch::Plugins
  class DiceRollCustom
    include Cinch::Plugin

    set plugin_name: "Custom Dice Roller",
    help: "Default dice rolling plugin from the Cinch example files with modifications for text output formatting."

    # [[<repeats>#]<rolls>]d<sides>[<+/-><offset>]
    match(/roll (?:(?:(\d+)#)?(\d+))?d(\d+)(?:([+-])(\d+))?/)
    def execute(m, repeats, rolls, sides, offset_op, offset)
      repeats = repeats.to_i
      repeats = 1 if repeats < 1
      rolls   = rolls.to_i
      rolls   = 1 if rolls < 1

      total = 0

      repeats.times do
        rolls.times do
          score = rand(sides.to_i) + 1
          if offset_op
            score = score.send(offset_op, offset.to_i)
          end
          total += score
        end
      end

      m.reply("#{Format(:yellow, "#{m.user} rolled a #{total}.")}", false)
    end
  end
end