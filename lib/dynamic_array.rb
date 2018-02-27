require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @store = StaticArray.new
    @length = 0
    @capacity = 8
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if index >= @length
    @store[index]
  end

  # O(1)
  def []=(index, value)
    @length += 1
    @store[index] = value
  end

  # O(1)
  def pop
    @store[length] = nil
    @length -= 1
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if @length == @capacity
    @store[length] = val
    @length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    @store[@length - @length] = nil
    @length -= 1
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if @length == @capacity
    new_store = StaticArray.new(@capacity)
    new_store[0] = val
    i = 0
    while i < @length
      new_store[1 + i] = @store[i]
      i+=1
    end
    @length += 1
    @store = new_store
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    @capacity *= 2
    new_store = StaticArray.new(@capacity)

    @store.each_with_index do |el,i|
      new_store[i] = el
    end
    @store = new_store
  end
end
