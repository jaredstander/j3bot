# Code originally from the cinch-haiku plugin
# https://github.com/cinchrb/cinch-haiku
# Only change was to format the output color of the text
# Please give credit where credit is due.

module Cinch::Plugins
  class HaikuCustom
    include Cinch::Plugin

    match "haiku", method: :print_haiku
    def print_haiku(m)
      html = Nokogiri::HTML(open("http://www.dailyhaiku.org/haiku/?pg=#{rand(220) + 1}"))
      haikus = html.search('p.haiku').to_a
      haiku_lines = haikus.sample.text.split(/[\r\n]+/)

      width = haiku_lines.inject(0) { |max, line|
        [line.length, max].max
      }

      haiku_lines.each do |line|
        sleep config[:delay] if config[:delay]
        m.reply("#{Format(:yellow, "#{' ' + line.center(width)}")}")
      end
    end
  end
end