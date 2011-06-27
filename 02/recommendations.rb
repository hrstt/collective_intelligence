# -*- coding:utf-8 -*-

require '../lib/PCIData.rb'
require '../lib/Misc.rb'
require 'set'

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
  m = Object.method(metric)
  scores = prefs.keys.collect {|other|
    [m.call(prefs, person, other), other] if other != person
  }.compact
  
  scores.sort.reverse[0,n]
end


if __FILE__ == $0
  p sim_distance(PCIData.critics, 'Lisa Rose', 'Gene Seymour')
  p sim_pearson(PCIData.critics, 'Lisa Rose', 'Gene Seymour')
  
  p top_matches(PCIData.critics, 'Toby')
end