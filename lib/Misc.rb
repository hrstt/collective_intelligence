#-*- coding:utf-8 -*-
class Array
  def sum
    self.inject(0) {|sum, v| sum + v}
  end
  
  def product
    self.inject(1) {|sum, v| sum * v}
  end
    
  def each_sum(other)
    self.zip(other).collect{|s, o| s + o}
  end

  def each_average(other, n)
    self.zip(other).collect{|s, o| s + o / n}
  end

  def sum_of_square
    self.inject(0) {|sum, v| sum + (v**2)}
  end
  
  def sum_of_product(other)
    self_enum = self.to_enum
    other_enum = other.to_enum
    
    result = []
    loop do
      result << self_enum.next * other_enum.next
    end
    result.sum
  end
  
  def variant
    self.sum_of_square - (self.sum ** 2) / self.size
  end

  def pearson(other)
    den = Math.sqrt(self.variant * other.variant)
    return 0 if den.zero?
    
    (self.sum_of_product(other) - (self.sum * other.sum / self.size)) / den
  end
end

def normalize_rank(n)
  1 / (1 + Math.sqrt(n))
end

