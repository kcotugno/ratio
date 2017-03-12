/*
 * Copyright (C) 2017 Kevin Cotugno
 * All rights reserved
 *
 * Distributed under the terms of the MIT software license. See the
 * accompanying LICENSE file or http://www.opensource.org/licenses/MIT.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 256

int* bubble_sort(int* unsorted, const int count)
{
        int t;

        for (int i = 0; i < count; i++) {
                for (int j = 0; j < (count - i - 1); j++) {
                        if (unsorted[j] > unsorted[j + 1]) {
                                t = unsorted[j];
                                unsorted[j] = unsorted[j + 1];
                                unsorted[j + 1] = t;
                        }
                }
        }

        return unsorted;
}

char* array_to_str(char* buffer, const int* array, int buffer_sz, int array_sz)
{
        char unsorted[BUFFER_SIZE];
        char result[BUFFER_SIZE];
        memset(result, '\0', sizeof(char) * BUFFER_SIZE);

        for (int i = 0; i < array_sz; i++) {
                snprintf(unsorted, BUFFER_SIZE, "%d", array[i]);
                strncat(result, unsorted, BUFFER_SIZE);

                if (i + 1 != array_sz)
                        strncat(result, ", ", 2);
        }

        strncpy(buffer, result, buffer_sz - 1);

        return buffer;
}

int main(void)
{
        char buffer[BUFFER_SIZE];
        int num;

        printf("How many elements? ");
        fgets(buffer, BUFFER_SIZE, stdin);

        num = atoi(buffer);

        int elements[num];
        for(int i = 0; i < num; i++) {
                printf("Enter element %d: ", i + 1);
                fgets(buffer, BUFFER_SIZE, stdin);
                elements[i] = atoi(buffer);
        }


        printf("Unsorted: [%s]\n", array_to_str(buffer, elements, BUFFER_SIZE, num));
        bubble_sort(elements, num);
        printf("Sorted:   [%s]\n", array_to_str(buffer, elements, BUFFER_SIZE, num));

        return 0;
}
