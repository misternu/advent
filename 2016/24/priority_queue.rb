class PriorityQueue
  def initialize
    @queue = {}
  end

  def add(element, priority)
    @queue[element] = priority
  end

  def pull
    top = @queue.min_by { |k,v| v } .first
    @queue.delete(top)
    top
  end

  def empty?
    @queue.empty?
  end
end