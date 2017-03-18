;------------------------------------------------------------------------------
; Copyright (C) 2017 Kevin Cotugno
; All rights reserved
;
; Distributed under the terms of the MIT software license. See the
; accompanying LICENSE file or http://www.opensource.org/licenses/MIT.
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; This program uses Linux system calls and can therefore only be run there
;
; build: nasm -f elf64 asm/bubble_sort.asm
; link:  ld asm/bubble_sort.o -o bubble_sort
;------------------------------------------------------------------------------


section .text
  global _start

;-------------------------------------------------------------------------------
; _start: Program entry point
;-------------------------------------------------------------------------------
_start:
  mov     rax, 1          ; Print the initial question
  mov     rdi, 1
  mov     rsi, amount
  mov     rdx, amount.len
  syscall

  sub     rsp, 0x100
  mov     rsi, rsp        ; Allocate space to hold the user input

  mov     rax, 0          ; Recieve user input
  mov     rdi, 0
  mov     rdx, 0x100
  syscall
  dec     rax             ; Remove the new line
  jz     .end             ; If there are no chars exit

  mov     rsi, rsp
  mov     rdx, rax
  call    atol            ; Convert the input to an integer

  mov     r8, rax         ; Move it so we can do some multiplication

  mov     rdx, 8
  mul     rdx

  sub     rsp, rax
  push    rax
  push    r8

  mov     rax, r8         ; Get the values to sort
  mov     rdi, rsp
  add     rdi, 16
  call    getelements

  mov     rax, 1          ; Print the unsorted array
  mov     rdi, 1
  mov     rsi, unsorted
  mov     rdx, unsorted.len
  syscall

  mov     rax, [rsp]      ; Convert the unsorted array to a string
  mov     rsi, rsp
  add     rsi, 16
  sub     rsp, 0x20
  mov     rdi, rsp
  mov     rdx, 0x20
  call    arrayltostr

  mov     byte [rsp+rax], 10 ; Add a new line
  add     rax, 1

  mov     rdx, rax        ; Print the unsorted array
  mov     rax, 1
  mov     rdi, 1
  mov     rsi, rsp
  syscall

  add     rsp, 0x20

  mov     rax, [rsp]      ; Retreive the count
  mov     rsi, rsp
  add     rsi, 16
  call    bubblesort

  mov     rax, 1          ; Print the unsorted array
  mov     rdi, 1
  mov     rsi, sorted
  mov     rdx, sorted.len
  syscall

  pop     rax             ; Retreive the count

  mov     rsi, rsp        ; Convert the sorted array to a string
  add     rsi, 8
  sub     rsp, 0x20
  mov     rdi, rsp
  mov     rdx, 0x20
  call    arrayltostr

  mov     byte [rsp+rax], 10 ; Add a new line
  add     rax, 1

  mov     rdx, rax        ; Print the sorted array
  mov     rax, 1
  mov     rdi, 1
  mov     rsi, rsp
  syscall

  add     rsp, 0x20

  pop     rax
  add     rsp, rax

.end:

  add     rsp, 0x100      ; Reset the stack

  mov     rax, 60         ; Exit
  syscall

;-------------------------------------------------------------------------------
; end _start
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; bubblesort: Sort an array
;
; rax: The number of elements
; rsi: The elements
;-------------------------------------------------------------------------------
bubblesort:
  mov     r10, 8
  mul     r10           ; Get the number of elements times the size

  mov     rcx, rax
  cmp     rcx, 0
  jle      .end

.loop:
  cmp     rcx, 0        ; Check if we're done
  jl      .end

  push    rcx
  push    rax

  sub     rax, rcx      ; Don't check already sorted elements
  sub     rax, 8
.loop2:
  cmp     rax, 8
  jl      .el2

  mov     r10, rsi    ; Get a copy of the pointer
  add     r10, rax    ; And set it to the current index

  sub     rax, 8      ; Move to the next element

  mov     r8, [r10]   ; Copy the current values
  mov     r9, [r10-8]

  cmp     r8, r9      ; Check if the switch should be made
  jg      .loop2

  mov     [r10], r9   ; Switch
  mov     [r10-8], r8

  jmp     .loop2

.el2:

  pop     rax
  pop     rcx
  sub     rcx, 8      ; Next
  jmp     .loop

.end:

  ret

;-------------------------------------------------------------------------------
; end bubblesort
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; getelements: Get the element for the sorting
;
; rax: The number of elements for which to ask
; rdi: The array to hold them in.
;-------------------------------------------------------------------------------
getelements:
  sub     rsp, 0x20     ; A place for the message

  xor     r9, r9
.loop:
  cmp     rax, 0
  jz      .end
  dec     rax
  inc     r9

  push    rax
  push    r9
  push    rdi

  mov     rax, 1
  mov     rdi, 1
  mov     rsi, element
  mov     rdx, element.len
  syscall

  mov     rax, [rsp+8]    ; Get the element number for the message

  mov     rdi, rsp
  add     rdi, 24
  mov     rdx, 0x20
  call    ltostr

  mov     r9, rsp       ; Get the base address to add the colon
  add     r9, 24
  add     r9, rax       ; Add the current number of chars
  mov     byte [r9], 58
  mov     byte [r9+1], 32

  mov     rdx, rax      ; Set the length for printing
  add     rdx, 2

  mov     rax, 1        ; Print the number
  mov     rdi, 1
  mov     rsi, rsp
  add     rsi, 24
  syscall

  mov     rax, 0        ; Get an element
  mov     rdi, 0
  mov     rsi, rsp
  add     rsi, 24
  mov     rdx, 0x20
  syscall
  dec     rax
  jz     .end

  mov     rsi, rsp      ; Convert it to a long
  add     rsi, 24
  mov     rdx, rax
  call    atol

  pop     rdi

  mov     [rdi], rax    ; Add long to the array
  add     rdi, 8

  pop     r9

  pop     rax
  jmp     .loop

.end:
  add     rsp, 0x20

  ret

;-------------------------------------------------------------------------------
; end getelements
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; arrayltostr: Array of longs to string
;
; rax: Number of elements
; rsi: Pointer to bottom of array
; rdi: Pointer to buttom of destination
; rdx: Max size of destination
;
; rax: Number of chars
;-------------------------------------------------------------------------------

arrayltostr:
  mov     rcx, rax
  xor     r9, r9

  cmp     rdx, 2
  jl      .end

  mov     byte [rdi], 91 ; Add an opening bracket
  inc     r9
  inc     rdi


.loop:

  push    rcx
  push    rdi
  push    rdx
  push    rsi
  push    r9

  mov     rax, [rsi]  ; Convert the long
  call    ltostr

  pop     r9          ; Increase the char count
  add     r9, rax

  pop     rsi
  add     rsi, 8

  pop     rdx
  sub     rdx, rax    ; Less room in the buffer

  pop     rdi
  add     rdi, rax    ; Move up the destination

  pop     rcx

  dec     rcx         ; Transverse the array
  jz      .end

  mov     byte [rdi], 44 ; Add the comma and space
  mov     byte [rdi+1], 32

  add     r9, 2       ; Increase the counts by 2
  sub     rdx, 2
  add     rdi, 2

  jmp     .loop

.end:

  mov     byte [rdi], 93 ; Add a closing bracket
  add     r9, 1

  mov     rax, r9
  ret

;-------------------------------------------------------------------------------
; end arrayltostr
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; atol: String to long
;
; rax: The number of chars in the buffer
; rsi: Pointer to the buffer
;
; rax: The long from the string
;-------------------------------------------------------------------------------
atol:
  mov     rcx, rdx
  xor     rax, rax

.tolloop:
  push    rcx
  push    rax

  mov     rax, 1

.dec:                     ; Set the tenths place
  dec     rcx
  jz     .conv            ; If there's only one char skip

  mov     rdx, 10
  mul     rdx

  jmp     .dec

.conv:                    ; Convert the input
  xor     rdx, rdx
  mov     dl, byte [rsi]

  sub     rdx, 48
  mul     rdx

  pop     rdx
  add     rax, rdx

  add     rsi, 1          ; Move to the next element

  pop     rcx
  dec     rcx
  jne     .tolloop

  ret

;-------------------------------------------------------------------------------
; end atol
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; ltostr: Long to string
;
; rax: The long to convert
; rdi: Buffer to hold the chars
; rdx: The size of the buffer
;
; rax: Number of chars
;-------------------------------------------------------------------------------
ltostr:
  push    rdi

  mov     r8, 10
  xor     r9, r9          ; Hold the char count
.tostrloop:
  push    rdx
  inc     r9              ; Increment the char count

  xor     rdx, rdx        ; Don't accidently make the number bigger

  div     r8              ; rax always has the dividend
  add     rdx, 48         ; Add 48 to the remainder

  mov     [rdi], dl

  inc     rdi

  pop     rdx             ; Stop if we've hit the top of the buffer
  cmp     r9, rdx
  je      .end

  cmp     rax, 0
  jnz     .tostrloop

.end:

  pop     rdi

  push r9

  mov     rdx, r9
  call    flip            ; Flip the bytes

  pop rax

  ret

;-------------------------------------------------------------------------------
; end ltostr
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; flip: Flip a given number of bytes
;
; rdi: Bottom of bytes to flip
; rdx: Number of bytes
;-------------------------------------------------------------------------------
flip:
  mov     rsi, rdi        ; Copy the stack pointer
  add     rsi, rdx        ; Set the copy to the top
  dec     rsi             ; We're one too high

.loop:
  cmp     rdx, 2          ; See if we're done
  jl      .end

  mov     byte r8b, [rdi] ; Flip the bytes!
  mov     byte r9b, [rsi]

  mov     byte [rsi], r8b
  mov     byte [rdi], r9b

  inc     rdi             ; Increment the bottom buffer pointer
  dec     rsi             ; Recrement the top buffer pointer
  sub     rdx, 2          ; Subtract the count

  jmp     .loop

.end:

  ret

;-------------------------------------------------------------------------------
; end flip
;-------------------------------------------------------------------------------

section .data

amount  db  'How many elements? ', 0
.len    equ $-amount
element db  'Enter element ', 0
.len    equ $-element
unsorted db 'Unsorted: '
.len    equ $-unsorted
sorted db 'Sorted:   '
.len    equ $-sorted
