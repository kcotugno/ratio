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

func copy(to_copy []int) []int {
    copy := make([]int, len(to_copy))

    for i, v := range to_copy {
        copy[i] = v
    }

    return copy
}

func BubbleSort(unsorted []int) []int {
    sorted := copy(unsorted)
    count := len(sorted)

    for i := 0; i < count; i++ {
        for j := 0; j < (count - i - 1); j++ {
            if sorted[j] > sorted[j + 1] {
                t := sorted[j]
                sorted[j] = sorted[j + 1]
                sorted[j + 1] = t
            }
        }
    }

    return sorted
}

func main() {
    var input string
    fmt.Printf("All elements must be integers\n")

    fmt.Printf("How many elements? ")
    fmt.Scanln(&input)

    num, _ := strconv.Atoi(input)

    var elements = make([]int, num)
    for i := range elements {
        fmt.Printf("Enter element %v: ", i + 1)
        fmt.Scanln(&input)
        elements[i], _ = strconv.Atoi(input)
    }

    fmt.Printf("Sorted:   %v\n", BubbleSort(elements))
    fmt.Printf("Unsorted: %v\n", elements)
}
