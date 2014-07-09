require "active_support/core_ext/hash/indifferent_access"
require "wordnik"
require "yaml"

module Cinch::Plugins
  class Define
    include Cinch::Plugin

    wordnik_config = HashWithIndifferentAccess.new(YAML.load(File.read(File.expand_path('../../yaml/wordnik.yml', __FILE__))))

    Wordnik.configure do |config|
      config.api_key = wordnik_config[:secret_key]
    end

    match /define (.+)/, method: :define_word

    def define_word(m, word)
      word_def = Wordnik.word.get_definitions(word)
      if word_def[0] == nil
        m.reply("#{Format(:yellow, "Cannot define, #{word} not found.")}", false)
      else
        m.reply("#{Format(:yellow, "#{word.capitalize} - #{word_def[0]["partOfSpeech"].capitalize}: \"#{word_def[0]["text"].strip == nil ? word_def[0]["text"].gsub(/\s{2,}/, " ") : word_def[0]["text"].gsub(/\s{2,}/, " ").strip}\"")}", false)
      end
    end

  end
end