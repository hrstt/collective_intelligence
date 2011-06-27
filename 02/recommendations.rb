# -*- coding:utf-8 -*-

require '../lib/PCIData.rb'
require '../lib/Misc.rb'
require 'set'

class Recommendations
  # return common key name set
  def common_key_set(prefs, k1, k2)
    si = Set.new
    prefs[k1].each_key {|item| si.add(item) if prefs[k2].key?(item)}
    si
  end

  def sim_distance(prefs, person1, person2)
    # person1 and person2 shared item
    si = common_key_set(prefs, person1, person2)
  
    # if person1 and person2 have no item in common
    return 0 if si.size.zero?

    sum_of_squares = si.collect {|item| (prefs[person1][item] - prefs[person2][item]) ** 2}.sum
    normalize_rank(sum_of_squares)
  end

  def sim_pearson(prefs, person1, person2)
    # person1 and person2 shared item
    si = common_key_set(prefs, person1, person2)
  
    n = si.size
    return 0 if n.zero?
  
    # sum pu all the preferences
  
    collection1 = si.collect {|item| prefs[person1][item]}
    collection2 = si.collect {|item| prefs[person2][item]}
  
    # sum up all the preferences
    sum1 = collection1.sum
    sum2 = collection2.sum
  
    # sum up all the square
    sum1_sq = collection1.sum_of_square
    sum2_sq = collection2.sum_of_square
  
    # sum up the products
    p_sum = si.collect {|item| prefs[person1][item] * prefs[person2][item]}.sum
  
    # caluculate Pearson score
    # usually, pearson r = sum{(x - mean(x))(y - mean(y))} / sqrt(sum(x - mean(x))**2) * sum(y - mean(y)**2 ))
    # in this code, simplify calucuation like this.
    # r(molecular) = sum(x * y) - sum(x) * mean(y) - mean(x) * sum(y) + sum(mean(x) * mean(y))
    #              = sum(x * y) - {sum(x) * sum(y)}/n - {sum(x) * sum(y)}/n + {sum(x) * sum(y)}/n
    #              = sum(x * y) - {sum(x) * sum(y)}/n
    #              = p_sum - (sum1 * sum2)/n
    # r(denominator) = sqrt(sum(x - mean(x))^2 * sum(y - mean(y))^2)
    #                = sqrt{ (sum(x)^2 - sum(x)^2/n) * (sum(y)^2 - sum(y)^2/n) }
    #                = Math.sqrt((sum1_sq-(sum1**2)/n)*(sum2_sq-(sum2**2)/n))
    den = Math.sqrt((sum1_sq-(sum1**2)/n)*(sum2_sq-(sum2**2)/n))
    return 0 if den.zero?
  
    (p_sum - (sum1*sum2/n))/den
  
  end
  def top_matches(prefs, person, n=5, metric=:sim_pearson)
    m = self.method(metric)
    scores = prefs.keys.collect {|other|
      [m.call(prefs, person, other), other] if other != person
    }.compact

    scores.sort.reverse[0,n]
  end

  def get_recommendations(prefs, person, metric=:sim_pearson)
    m = self.method(metric)
    totals = Hash.new(0)
    sim_sums = Hash.new(0)
    prefs.each_key do |other|
      next if other == person
      sim = m.call(prefs, person, other)
      
      next if sim <= 0
      
      prefs[other].each_key do |item|
        if not prefs[person].key?(item) or prefs[person][item].zero?
          totals[item] += prefs[other][item] * sim
          sim_sums[item] += sim
        end
      end
    end
    rankings = totals.collect {|item, total| [total/sim_sums[item], item]}
    rankings.sort.reverse
  end

end


if __FILE__ == $0
  p Recommendations.new.sim_distance(PCIData.critics, 'Lisa Rose', 'Gene Seymour')
  p Recommendations.new.sim_pearson(PCIData.critics, 'Lisa Rose', 'Gene Seymour')
  
  p Recommendations.new.top_matches(PCIData.critics, 'Toby')
  p Recommendations.new.get_recommendations(PCIData.critics, 'Toby')
  p Recommendations.new.get_recommendations(PCIData.critics, 'Toby', :sim_distance)
  
  p Recommendations.new.top_matches(PCIData.movies, 'Superman Returns')
  p Recommendations.new.get_recommendations(PCIData.movies, 'Just My Luck')
end