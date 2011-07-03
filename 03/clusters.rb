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

  def hcluster(rows, distance=:pearson)
    distances = Hash.new
    current_cluster_id = -1

    m = self.method(distance)
    
    clust = (0...rows.size).collect {|i| Bicluster.new(rows[i], id=i) }
    while clust.size > 1
      lowest_pair = [0,1]
      closest = 1.0
      
      range = clust.size
      (0...range).each do |i|
        (i+1...range).each do |j|
          
          key = [clust[i].id, clust[j].id]

          d = unless distances.key?(key)
            distances[key] = m.call(clust[i].vec, clust[j].vec)
          else
            distances[key]
          end
          if d < closest
            closest = d
            lowest_pair = [i,j]
          end
        end
      end
      
      merge_vec = clust[lowest_pair[0]].vec.each_average(clust[lowest_pair[1]].vec, 2)
      
      new_cluster = Bicluster.new(merge_vec, id=current_cluster_id, left=clust[lowest_pair[0]], right=clust[lowest_pair[1]], distance=closest)
      current_cluster_id -= 1
      clust.delete_at(lowest_pair[1])
      clust.delete_at(lowest_pair[0])
      clust << new_cluster
    end

    clust[0]
  end

  def print_clust(clust, labels=nil, n=0)
    line = '  ' * n
    line += if clust.leaf?
      if labels then labels[clust.id] else clust.id end
    else
      '-'
    end
    p line
    print_clust(clust.left, labels, n+1) if clust.left
    print_clust(clust.right, labels, n+1) if clust.right
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
  
  def leaf?
    @left == nil && @right == nil
  end
end

if __FILE__ == $0
  rownames, colnames, data = Clusters.new.read_file('./blogdata.txt')
  cluster = Clusters.new.hcluster(data[0..8])
  Clusters.new.print_clust(cluster, rownames)
end