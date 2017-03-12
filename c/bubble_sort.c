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

int* bubble_sort(int* sorted, const int* values, const int count)
{
        int temp[count];
        int holder;

        memcpy(temp, values, sizeof(int) * count);

        for (int i = 0; i < count; i++) {
                for (int j = 0; j < (count - i - 1); j++) {
                        if (temp[j] > temp[j + 1]) {
                                holder = temp[j];
                                temp[j] = temp[j + 1];
                                temp[j + 1] = holder;
                        }
                }
        }

        memcpy(sorted, temp, sizeof(int) * count);
        return sorted;
}

char* array_to_str(char* buffer, const int* array, int buffer_sz, int array_sz)
{
        char temp[BUFFER_SIZE];
        char result[BUFFER_SIZE];
        memset(result, '\0', sizeof(char) * BUFFER_SIZE);

        for (int i = 0; i < array_sz; i++) {
                snprintf(temp, BUFFER_SIZE, "%d", array[i]);
                strncat(result, temp, BUFFER_SIZE);

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

        printf("All elements must be integers\n");
        printf("How many elements? ");
        fgets(buffer, BUFFER_SIZE, stdin);

        num = atoi(buffer);

        int elements[num];
        for(int i = 0; i < num; i++) {
                printf("Enter element %d: ", i + 1);
                fgets(buffer, BUFFER_SIZE, stdin);
                elements[i] = atoi(buffer);
        }


        int sorted[num];
        bubble_sort(sorted, elements, num);

        printf("Sorted:   [%s]\n", array_to_str(buffer, sorted, BUFFER_SIZE, num));
        printf("Unsorted: [%s]\n", array_to_str(buffer, elements, BUFFER_SIZE, num));

        return 0;
}
