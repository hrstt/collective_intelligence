class Array
  def sum
    self.inject(0) {|sum, value| sum += value}
  end
  
  def sum_of_square
    self.inject(0) {|sum, value| sum = sum + (value**2)}
  end
end

def normalize_rank(n)
  1 / (1 + Math.sqrt(n))
end

