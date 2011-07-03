#-*- coding:utf-8 -*-
class Array
  def sum
    self.inject(0) {|sum, value| sum += value}
  end
  
  def sum_of_square
    self.inject(0) {|sum, value| sum = sum + (value**2)}
  end
  
  def product(other)
    self_enum = self.to_enum
    other_enum = other.to_enum
    
    result = []
    loop do
      result << self_enum.next * other_enum.next
    end
    result
  end
end

def normalize_rank(n)
  1 / (1 + Math.sqrt(n))
end

