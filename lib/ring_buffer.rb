require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @store = StaticArray.new
    @length = 0
    @start_idx = 0
    @capacity = 8
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if index == @length
    index = @start_idx + index
    index = index % @capacity
    @store[index]
  end

  # O(1)
  def []=(index, val)
    index = @start_idx + index
    index = index % @capacity
    @store[index] = val
  end

  # O(1)
  def pop
    raise "index out of bounds" if @length == 0
    num = (@length + @start_idx) % @capacity - 1
    old = @store[num]
    @store[num] = nil
    @length -= 1
    num
  end

  # O(1) ammortized
  def push(val)
    resize! if @length == @capacity
    @store[(@length + @start_idx) % @capacity] = val
    @length += 1
  end

  # O(1)
  def shift
    raise "index out of bounds" if @length == 0
    old = @store[@start_idx]
    @store[@start_idx] = nil
    @length -= 1
    @start_idx += 1
    old
  end

  # O(1) ammortized

  # physical index used in static array
  # logical index used in dynamic array
  def unshift(val)
    resize! if @length == @capacity
    @start_idx -= 1
    @start_idx = @start_idx % @capacity
    @store[start_idx] = val
    @length += 1
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
  end

  def resize!
    @capacity *= 2
    new_store = StaticArray.new(@capacity)
    i = 0
    while i < @length
      new_store[i] = @store[i]
      i+=1
    end
    @store = new_store
  end
end
