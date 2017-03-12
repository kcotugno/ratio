// Copyright (C) 2017 Kevin Cotugno
// All rights reserved
//
// Distributed under the terms of the MIT software license. See the
// accompanying LICENSE file or http://www.opensource.org/licenses/MIT.

package main

import (
    "fmt"
    "strconv"
)

func BubbleSort(unsorted []int) []int {
    count := len(unsorted)

    for i := 0; i < count; i++ {
        for j := 0; j < (count - i - 1); j++ {
            if unsorted[j] > unsorted[j + 1] {
                t := unsorted[j]
                unsorted[j] = unsorted[j + 1]
                unsorted[j + 1] = t
            }
        }
    }

    return unsorted
}

func main() {
    var input string

    fmt.Printf("How many elements? ")
    fmt.Scanln(&input)

    num, _ := strconv.Atoi(input)

    var elements = make([]int, num)
    for i := range elements {
        fmt.Printf("Enter element %v: ", i + 1)
        fmt.Scanln(&input)
        elements[i], _ = strconv.Atoi(input)
    }

    fmt.Printf("Unsorted: %v\n", elements)
    fmt.Printf("Sorted:   %v\n", BubbleSort(elements))
}
