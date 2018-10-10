/*
 * Copyright (C) 2018 Kevin Cotugno
 * All rights reserved
 *
 * Distributed under the terms of the MIT software license. See the
 * accompanying LICENSE file or http://www.opensource.org/licenses/MIT.
 */

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MEM_STEPS 2
#define BIT_SIZE 32

#define FALSE 0
#define TRUE 1

#define UPPER64_MASK 0xFFFFFFFF00000000
#define LOWER64_MASK 0x00000000FFFFFFFF

#define UPPER64(x) (x & UPPER64_MASK)
#define LOWER64(x) (x & LOWER64_MASK)

#define LSHIFT32(x) (x << BIT_SIZE)
#define RSHIFT32(x) (x >> BIT_SIZE)

#define SWAP(x, y) { void *tmp = x; x = y, y = tmp; }

typedef unsigned BOOL;

struct big_int {
	uint64_t count;
	uint64_t size;
	uint32_t* buf;
};

struct big_int* big_int_init(uint64_t x);
void big_int_destroy(struct big_int* i);
void big_int_internal_grow(struct big_int* i, size_t size, BOOL copy);
void big_int_grow(struct big_int* i, BOOL copy);
uint64_t big_int_bit_len(struct big_int* i);
void big_int_add(struct big_int *a, struct big_int *b);
void big_int_sub(struct big_int* a, struct big_int* b);

struct big_int* big_int_init(uint64_t x)
{
	struct big_int* i = (struct big_int*)calloc(1, sizeof(struct big_int));
	i->size = 1;
	i->count = 1;
	big_int_grow(i, FALSE);

	i->buf[0] = (uint32_t)LOWER64(x);
	i->buf[1] = (uint32_t)UPPER64(x);

	return i;
}

void big_int_destroy(struct big_int* i)
{
	free(i->buf);
	free(i);
}

void big_int_internal_grow(struct big_int* i, size_t size, BOOL copy)
{
	uint32_t* tmp;
	tmp = (uint32_t*)calloc(size, sizeof(uint32_t) * size);

	if (tmp == NULL) {
		printf("Unable to allocate memory");
		exit(1);
	}

	if (copy)
		memcpy(tmp, i->buf, sizeof(uint32_t) * (size_t)i->size);

	i->buf = tmp;
	i->size = size;
}

void big_int_grow(struct big_int* i, BOOL copy)
{
	size_t new_size = (size_t)i->size * MEM_STEPS;
	big_int_internal_grow(i, new_size, copy);
}

uint64_t big_int_bit_len(struct big_int* i)
{
	uint32_t j = 32;
	uint32_t x = i->buf[i->count - 1];

	if (x <= 0x0000ffff) j -= 16, x <<= 16;
	if (x <= 0x00ffffff) j -=  8, x <<= 8;
	if (x <= 0x0fffffff) j -=  4, x <<= 4;
	if (x <= 0x3fffffff) j -=  2, x <<= 2;
	if (x <= 0x7fffffff) j --;

	return j + ((i->count - 1) * 32);
}

void big_int_add(struct big_int *a, struct big_int *b)
{
	struct big_int* result = big_int_init(0);

	uint64_t tmp = 0;
	uint64_t carry = 0;
	uint64_t x, y;

	uint64_t i = 0;
	do {
		if (i == result->size) {
			big_int_grow(result, TRUE);
		}

		if (i < a->count) {
			x = (uint64_t)a->buf[i];
		} else {
			x = 0;
		}

		if (i < b->count) {
			y = (uint64_t)b->buf[i];
		} else {
			y = 0;
		}

		tmp = x + y;
		tmp = tmp + carry;
		carry = RSHIFT32(UPPER64(tmp));

		result->buf[i] = (uint32_t)LOWER64(tmp);

		i++;
	} while(i < a->count || i < b->count || carry > 0);

	SWAP(a->buf, result->buf);
	a->count = i;
	a->size = result->size;

	big_int_destroy(result);
}

void big_int_add_uint32(struct big_int* a, uint32_t b)
{
	big_int_add(a, big_int_init(b));
}

void big_int_sub(struct big_int* a, struct big_int* b)
{
	struct big_int* result = big_int_init(0);
	uint64_t tmp = 0;
	uint64_t carry = 0;

	uint64_t i = a->count + 2;
	do {
		uint64_t x = 0, y = 0;

		if (i - 2 < a->count) {
			x = (uint64_t)a->buf[i - 2];
		}

		x |= carry;

		if (i - 2 < b->count) {
			y = (uint64_t)b->buf[i - 2];
		}

		tmp = x - y;
		result->buf[i - 1] = (uint32_t)RSHIFT32(UPPER64(tmp));
		carry = LSHIFT32(LOWER64(tmp));

		--i;
	} while(i > 0);

	SWAP(a->buf, result->buf);
	a->size = result->size;

	big_int_destroy(result);
}

int main(void)
{
	struct big_int* bi = big_int_init(123456789);

	big_int_add_uint32(bi, 123456789);

	for (int i = 0; i < 10; i++)
		big_int_add(bi, bi);

	for (uint64_t i = 0; i < bi->count; i++)
		printf("[%" PRIu32 "] ", bi->buf[i]);
	printf("\n");

	big_int_sub(bi, big_int_init(53350));

	for (uint64_t i = 0; i < bi->count; i++)
		printf("[%" PRIu32 "] ", bi->buf[i]);
	printf("\n");

	printf("%lu\n", big_int_bit_len(bi));
	printf("%" PRIu64 "\n", bi->size);

	big_int_destroy(bi);

	return 0;
}
