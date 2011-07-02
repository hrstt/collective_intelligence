#-*- coding:utf-8 -*-

class PCIData
  def self.lib_dir
    File.expand_path(File.dirname(__FILE__))
  end

  # chapter 2
  def self.critics
    {
      'Lisa Rose'=> {'Lady in the Water'=> 2.5, 'Snakes on a Plane'=> 3.5, 'Just My Luck'=> 3.0, 'Superman Returns'=> 3.5, 'You, Me and Dupree'=> 2.5, 'The Night Listener'=> 3.0},
      'Gene Seymour'=> {'Lady in the Water'=> 3.0, 'Snakes on a Plane'=> 3.5, 'Just My Luck'=> 1.5, 'Superman Returns'=> 5.0, 'The Night Listener'=> 3.0, 'You, Me and Dupree'=> 3.5},
      'Michael Phillips'=> {'Lady in the Water'=> 2.5, 'Snakes on a Plane'=> 3.0, 'Superman Returns'=> 3.5, 'The Night Listener'=> 4.0},
      'Claudia Puig'=> {'Snakes on a Plane'=> 3.5, 'Just My Luck'=> 3.0, 'The Night Listener'=> 4.5, 'Superman Returns'=> 4.0, 'You, Me and Dupree'=> 2.5},
      'Mick LaSalle'=> {'Lady in the Water'=> 3.0, 'Snakes on a Plane'=> 4.0, 'Just My Luck'=> 2.0, 'Superman Returns'=> 3.0, 'The Night Listener'=> 3.0, 'You, Me and Dupree'=> 2.0},
      'Jack Matthews'=> {'Lady in the Water'=> 3.0, 'Snakes on a Plane'=> 4.0, 'The Night Listener'=> 3.0, 'Superman Returns'=> 5.0, 'You, Me and Dupree'=> 3.5},
      'Toby'=> {'Snakes on a Plane'=>4.5,'You, Me and Dupree'=>1.0,'Superman Returns'=>4.0}
    }
  end

  def self.movies
    result = Hash.new
    prefs = self.critics
    prefs.each_key do |person|
      prefs[person].each_key do |item|
        result[item] ||= Hash.new
        result[item][person] = prefs[person][item]
      end
    end
    result
  end

  # chapter 3
  def self.dropwords
    ['a','new','some','more','my','own','the','many','other','another']
  end

  def self.feed_list
    File.readlines(self.lib_dir + '/feedlist.txt').select{|line| line.chomp!}
  end
  
  # chapter 5
  def self.dorms
    ['Zeus','Athena','Hercules','Bacchus','Pluto']
  end
  
  def self.prefs
    [
      {'Toby'=> ['Bacchus', 'Hercules']},
      {'Steve' => ['Zeus', 'Pluto']},
      {'Karen' => ['Athena', 'Zeus']},
      {'Sarah' => ['Zeus', 'Pluto']},
      {'Dave' => ['Athena', 'Bacchus']}, 
      {'Jeff' => ['Hercules', 'Pluto']}, 
      {'Fred' => ['Pluto', 'Athena']}, 
      {'Suzie' => ['Bacchus', 'Hercules']},
      {'Laura' => ['Bacchus', 'Hercules']},
      {'James' => ['Hercules', 'Athena']}
    ]
  end

  def self.schedule
    File.readlines(self.lib_dir + '/schedule.txt').inject(Hash.new()) {|hash, item |
      origin,dest,depart,arrive,price = item.chomp!.split(',')
      hash[[origin,dest]] = [] if hash[[origin,dest]].nil?
      hash[[origin,dest]] << [depart, arrive, price.to_i]
      hash
    }
  end
  
  def self.socialnet_people
    ['Charlie','Augustus','Veruca','Violet','Mike','Joe','Willy','Miranda']
  end
  
  # chapter 5 & chapter 8
  def self.optimization_people
    [
      ['Seymour','BOS'],
      ['Franny','DAL'],
      ['Zooey','CAK'],
      ['Walt','MIA'],
      ['Buddy','ORD'],
      ['Les','OMA']
    ]
  end
  
  # chapter 7
  def self.stateregions
    {
      'New England' => ['ct','mn','ma','nh','ri','vt'],
      'Mid Atlantic' => ['de','md','nj','ny','pa'],
      'South' => ['al','ak','fl','ga','ky','la','ms','mo','nc','sc','tn','va','wv'],
      'Midwest' => ['il','in','ia','ks','mi','ne','nd','oh','sd','wi'],
      'West' => ['ak','ca','co','hi','id','mt','nv','or','ut','wa','wy']
    }
  end
  
  def tree_predict_data
    [
      ['slashdot','USA','yes',18,'None'],
      ['google','France','yes',23,'Premium'],
      ['digg','USA','yes',24,'Basic'],
      ['kiwitobes','France','yes',23,'Basic'],
      ['google','UK','no',21,'Premium'],
      ['(direct)','New Zealand','no',12,'None'],
      ['(direct)','UK','no',21,'Basic'],
      ['google','USA','no',24,'Premium'],
      ['slashdot','France','yes',19,'None'],
      ['digg','USA','no',18,'None'],
      ['google','UK','no',18,'None'],
      ['kiwitobes','UK','no',19,'None'],
      ['digg','New Zealand','yes',12,'Basic'],
      ['slashdot','UK','no',21,'None'],
      ['google','UK','yes',18,'Basic'],
      ['kiwitobes','France','yes',19,'Basic']
    ]
  end

  def self.addresslist
    File.readlines(self.lib_dir + '/addresslist.txt').select {|item| item.chomp!}
  end


  # chapter 9
  def self.matchmaker
    require 'csv'    
    CSV.readlines(self.lib_dir + '/matchmaker.csv')
  end
  
end

if __FILE__ == $0
  
  # p PCIData.feed_list
end