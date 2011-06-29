require 'rss'
require 'open-uri'

class GenerateFeedVector
  def self.get_word_counts(rss)
    word_count = Hash.new(0)

    open(rss) do |file|
      feed = RSS::Parser.parse(file.read)

      feed.items.each do |item|

        if defined?(item.summary)
          summary = item.summary
        else
          summary = item.description
        end
        
        words = self.get_words(item.title + ' ' + summary)

        words.inject(word_count) do |wc, word|
          wc[word] += 1
          wc
        end

      end
    end

    [rss,word_count]
  end
  
  def self.get_words(html)
    str = html.gsub(/<[^>]+>/).to_a.join(" ")
    words = str.split(/[^A-Z^a-z]+/)
    words.collect {|word| word.downcase}
  end
end

if __FILE__ == $0
  p GenerateFeedVector.get_word_counts("http://feeds.feedburner.com/37signals/beMH")
end