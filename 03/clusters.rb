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
    # reverse indicator of pearson
    1 - v1.pearson(v2)
  end
  
end

class Bicluster
  def initialize(vec, id=nil, left=nil, right=nil, distance=0.0)
    @vec = vec
    @id = id
    @left = left
    @right = right
    @distance = distance
  end
  attr_accessor :vec, :id, :left, :right, :distance
end

if __FILE__ == $0
  rownames, colnames, data = Clusters.new.read_file('./blogdata.txt')
  
  p Clusters.new.pearson(data[1],data[4])
  p Clusters.new.hcluster(data)
  
end