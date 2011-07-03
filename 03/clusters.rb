#-*- coding:utf-8 -*-

require '../lib/Misc.rb'

class Clusters
  def read_file(filename)
    lines = File.readlines(filename).select {|line| line.chomp!}
    
    colnames = lines.shift.split("\t")
    rownames = []
    data = []
    
    lines.each do |line|
      rowdata = line.split("\t")
      rownames << rowdata.shift
      data << rowdata.collect {|item| item.to_i}
    end
    
    [rownames, colnames, data]
  end
  
  def pearson(v1, v2)
    sum1 = v1.sum
    sum2 = v2.sum
    sum1_sq = v1.sum_of_square
    sum2_sq = v2.sum_of_square
    product_sum = v1.product(v2).sum
    
    n = v1.size
    
    den = Math.sqrt((sum1_sq-(sum1**2)/n)*(sum2_sq-(sum2**2)/n))
    return 0 if den.zero?

    # reverse indicator of pearson
    1 - (product_sum - (sum1*sum2/n))/den
    
    
  end
  
end

if __FILE__ == $0
  rownames, colnames, data = Clusters.new.read_file('./blogdata.txt')
  
  p Clusters.new.pearson(data[1],data[4])
  
end