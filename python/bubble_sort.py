# Copyright (C) 2017 Kevin Cotugno
# All rights reserved
#
# Distributed under the terms of the MIT software license. See the
# accompanying LICENSE file or http://www.opensource.org/licenses/MIT.

import copy

def bubble_sort(unsorted):
    count = len(unsorted)
    sort = copy.deepcopy(unsorted)

    for i in range(count):
        for j in range(count - i - 1):
            if sort[j] > sort[j + 1]:
                t = sort[j]
                sort[j] = sort[j + 1]
                sort[j + 1] = t

    return sort

print("All elements must be integers")
num = input("How many elements? ")

try:
    num = int(num)

    elements = []
    for i in range(num):
        elements.append(int(input("Enter element {0}: ".format(i + 1))))

except:
    exit(1)

print("Sorted:   {0}".format(bubble_sort(elements)))
print("Unsorted: {0}".format(elements))
