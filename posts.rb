# Machine Learning in Customer Success
## Cluster Analysis
@posts = Post.all

@words = @posts.map do |p|
  p.body.split(' ')
end.flatten.uniq

@vectors = @posts.map do |p|
  @words.map do |w|
    p.body.include?(w) ? 1 : 0
  end
end

# posts now is = [1,0,1,0,1,1,0,0] which can be compared!

@cluster_centers = [rand_point(), rand_point()]

15.times do
  @clusters = [[], []]

  @posts.each do |post|
    min_distance, min_point = nil, nil

    @cluster_centers.each.with_index do |center, i|
      if distance(center, post) < min_distance
        min_distance = distance(center, post)
        min_point = i
      end
    end

    @clusters[min_point] << post
  end

  @cluster_centers = @clusters.map do |post|
    average(posts)
  end
end
