require "open-uri"
require "nokogiri"

module Cinch::Plugins
  class ShowURLTitle
    include Cinch::Plugin

    set plugin_name: "Show URL Title",
    help: "Scrapes the titles of URLs mentioned and announces them."

    listen_to :channel

    def show_url_title(url)
      doc = Nokogiri::HTML(open(url))
      doc.title == nil ? "No title" : doc.title
      doc.title.strip == nil ? doc.title : doc.title.strip
    end

    def shorten(url)
      url = open("http://tinyurl.com/api-create.php?url=#{URI.escape(url)}").read
      url == "Error" ? nil : url
    rescue OpenURI::HTTPError
      nil
    end

    def listen(m)
      urls = URI.extract(m.message, /(https|http)/)
      unless urls.empty?
        url_titles = urls.map {|url| show_url_title(url) }.compact
        urls.each_with_index do |url, index|
          if url.length > 130
            url_titles[index] += " (#{shorten(url)})"
          end
        end
        m.reply("#{Format(:yellow, url_titles.join(", "))}", false)
      end
    end
  end
end