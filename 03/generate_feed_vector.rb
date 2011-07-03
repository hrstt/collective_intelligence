require 'rss'
require 'open-uri'
require '../lib/PCIData'

class GenerateFeedVector
  def get_word_counts(rss)
    word_count = Hash.new(0)
    title = ""

    open(rss) do |file|
      feed = RSS::Parser.parse(file.read)

      title = feed.channel.description.chomp!
      
      feed.items.each do |item|

        if defined?(item.summary)
          summary = item.summary
        else
          summary = item.description
        end
        
        words = get_words(item.title + ' ' + summary)

        words.inject(word_count) do |wc, word|
          wc[word] += 1
          wc
        end

      end
    end

    [title,word_count]
  end
  
  def get_words(html)
    str = html.gsub(/<[^>]+>/).to_a.join(" ")
    words = str.split(/[^A-Z^a-z]+/)
    words.collect {|word| word.downcase}
  end
  
  def all_feed_count(feed_list)
    apcount = Hash.new(0)
    word_counts = Hash.new(0)
    
    feed_list.each do |url|
      begin
        title, wc = get_word_counts(url)
        word_counts[title] = wc
        wc.inject(apcount) {|ap, (word, count)| ap[word] += 1 unless count.zero?; ap}
      rescue
        p 'Failed to parse feed %s' % url
      end
    end
    
    word_list = word_filter(apcount, feed_list.size)
    
    File.open('blogdata.txt', 'w') do |f|
      f << "Blog"
      f << word_list.collect {|word| "\t" + word }
      f << "\n"
      word_counts.each_pair do |title, words|
        f << title
        word_list.each do |word|
          f << (if words.key?(word) then ("\t" + words[word].to_s)  else "\t0" end )
        end
        f << "\n"
      end
    end
    
  end
  
  def word_filter(apcount, feed_size)
    result = []
    apcount.each_pair do |(k, v)|
      frac = v.to_f / feed_size
      result << k if frac > 0.1 and frac < 0.5
    end
    result
  end
end

if __FILE__ == $0
  GenerateFeedVector.new.all_feed_count(PCIData.feed_list)
end