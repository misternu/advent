class Unjammer
  def self.frequencies(array)
    array.reduce(Hash.new(0)) { |h,v| h[v] += 1; h }
  end

  def self.unjam(signal, options = {})
    # Group the letters by which position they are in
    letters = signal.map { |s| s.split('') }.transpose

    # Map the right letter on to each group
    letters.map do |set|
      freq = self.frequencies(set)
      # If the mod option is passed, use min instead of max
      best = options[:mod] ? freq.min_by(&:last) : freq.max_by(&:last)
      # Get the associated key
      best[0]
    end .join # Join into a single string
  end
end