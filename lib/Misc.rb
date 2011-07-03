#-*- coding:utf-8 -*-
class Array
  def sum
    self.inject(0) {|sum, v| sum += v}
  end
  
  def product
    self.inject(0) {|sum, v| sum += v}
  end
  
  def sum_of_square
    self.inject(0) {|sum, v| sum = sum + (v**2)}
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
end

def normalize_rank(n)
  1 / (1 + Math.sqrt(n))
end

