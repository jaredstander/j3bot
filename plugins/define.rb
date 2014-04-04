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
      m.reply("#{Format(:yellow, "#{word.capitalize} - #{word_def[0]["partOfSpeech"].capitalize}: \"#{word_def[0]["text"]}\"")}", false)
    end

  end
end