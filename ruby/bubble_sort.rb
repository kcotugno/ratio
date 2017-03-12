# Copyright (C) 2017 Kevin Cotugno
# All rights reserved
#
# Distributed under the terms of the MIT software license. See the
# accompanying LICENSE file or http://www.opensource.org/licenses/MIT.

def bubble_sort(unsorted)
  count = unsorted.count

   count.times do |i|
    (count - i - 1).times do |j|
      if unsorted[j] > unsorted[j+1]
        t = unsorted[j]
        unsorted[j] = unsorted[j+1]
        unsorted[j+1] = t
      end
    end
  end

  unsorted
end

print 'How many elements? '
num = gets.to_i

elements = Array.new(num) do |i|
  print "Enter element #{i + 1}: "
  gets.to_i
end

print "Unsorted: #{elements}\n"
print "Sorted:   #{bubble_sort(elements)}\n"
