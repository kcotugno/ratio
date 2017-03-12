/*
 * Copyright (C) 2017 Kevin Cotugno
 * All rights reserved
 *
 * Distributed under the terms of the MIT software license. See the
 * accompanying LICENSE file or http://www.opensource.org/licenses/MIT.
 */

using System;

class Ratio
{
    public static void Main(string[] args)
    {
        int num;
        int[] elements;

        Console.WriteLine("All elements must integers");
        Console.Write("How many elements? ");

        try {
            num = int.Parse(Console.ReadLine());

            elements = new int[num];
            for (int i = 0; i < num; i++)
            {
                Console.Write("Enter element {0}: ", i + 1);
                elements[i] = int.Parse(Console.ReadLine());
            }

            Console.WriteLine("Sorted:   [{0}]", string.Join(", ", BubbleSort(elements)));
            Console.WriteLine("Unsorted: [{0}]", string.Join(", ", elements));
        }
        catch {
            Environment.Exit(1);
        }

    }

    private static int[] BubbleSort(int[] unsorted)
    {
        var sorted = new int[unsorted.Length];
        unsorted.CopyTo(sorted, 0);
        var count = sorted.Length;
        int t;

        for (int i = 0; i < count; i++)
        {
            for (int j = 0; j < (count - i - 1); j++)
            {
                if (sorted[j] > sorted[j + 1])
                {
                    t = sorted[j];
                    sorted[j] = sorted[j + 1];
                    sorted[j + 1] = t;
                }
            }
        }

        return sorted;
    }
}
