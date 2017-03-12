# Copyright (C) 2017 Kevin Cotugno
# All rights reserved
#
# Distributed under the terms of the MIT software license. See the
# accompanying LICENSE file or http://www.opensource.org/licenses/MIT.

def bubble_sort(unsorted)
  sorted = unsorted.clone
  count = sorted.count

   count.times do |i|
    (count - i - 1).times do |j|
      if sorted[j] > sorted[j+1]
        t = sorted[j]
        sorted[j] = sorted[j+1]
        sorted[j+1] = t
      end
    end
  end

  sorted
end

puts 'All elements must be integers'
print 'How many elements? '
num = gets.to_i

elements = Array.new(num) do |i|
  print "Enter element #{i + 1}: "
  gets.to_i
end

print "Sorted:   #{elements}\n"
print "Unsorted: #{bubble_sort(elements)}\n"
