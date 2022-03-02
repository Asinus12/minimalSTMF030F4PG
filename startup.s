/* startup.s (as - GNU Assembler) https://docs.huihoo.com/redhat/rhel-4-docs/rhel-as-en-4/index.html */
/* @ ... can be used as a comment that extends to the end of the line */
/* ; ... can be used instead of a newline */
/* #, $ ... indicated immediate operand */
/* .thumb ... Performs the same action .code 16,  */
/* .thumb indicates T32 with UAL-ARM syntax */
/* .globl ... both .global and .globl are accepted for compatibility */
/* .thumb_func ... this directive specifies that the following symbol is the name of a Thumb encoded function */


// use thumb IS
.thumb             
// assembler flags -mcpu=cortex-m0 in makefile         
.cpu cortex-m0
//.syntax unified // causes error in LOOP 

// .globl ITERATIONS   /* export to C */
// ITERATIONS: .word 2


.section	.isr_vector,"a",%progbits
    .type	vector_table, %object
    .size	vector_table, .-vector_table
vector_table:
	.word	_endstack
	.word   reset



.word reset
.thumb_func
reset:
    ldr   r0, =_endstack   /* not really necessary, stack is propperly initialized */
    mov   sp, r0           /* not really necessary */
    bl __libc_init_array
    bl main
    b .



.thumb_func
.global SETFLASH
SETFLASH:
    ldr r2, =0x08000300
    ldr r3, =0x10101010
    str r3, [r2]

.thumb_func               
.globl PUT32                
PUT32:
    str r1,[r0]
    bx lr


.thumb_func
.globl GET32
GET32:
    ldr r0,[r0]
    bx lr


.thumb_func
.globl DUMMY
DUMMY:
    bx lr


.thumb_func
.globl LEDON
LEDON:
    ldr r1, =PA4_BSRR 
    ldr r3, =0x10
    str r3, [r1]
    bx lr


.thumb_func
.globl LEDOFF
LEDOFF: 
    ldr r1, =PA4_BSRR 
    ldr r3, =0x100000
    str r3, [r1]
    bx lr


.thumb_func
.globl LOOP
LOOP:
   ldr r1,=0x200000
label:
   sub r1, #1
   bne label
   bx lr      



