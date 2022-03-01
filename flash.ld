/* location counter (.) only appears inside sections, allways tracks VMA */



STACK_SIZE = 0x80; /* 128   */
PA4_BSRR = 0x48000018;
_sfaddr = 0x08000300;
_efaddr = 0x08000400;
_endstack = 0x20001000;

MEMORY
{
    rom : ORIGIN = 0x08000000, LENGTH = 18K
    ram : ORIGIN = 0x20000000, LENGTH = 5K 
}

SECTIONS
{   
    

    .isr_vector :          /* vectors go at start of flash */
    {
        _svector = . ;
        . = ALIGN(4);
         KEEP(*(.isr_vector)) 
        . = ALIGN(4);
        _evector = . ;
    } >rom

    .text :                 /* code, data */
    { 
        *(.text*)           /* wildcard * means we want all .text section in all files */
    } > rom


    .bss (NOLOAD) :         /* uninitialized data */   
    {
        _sbss = . ;         
        *(.bss*)
        *(COMMON)           /* int foo() yes, static int foo() no*/
        _ebss = . ;         
    } > ram


    .data :                 /* initializeed static varibles*/            
    {
        _sdata = . ;
        *(.data*);
        _edata = . ;
    } > ram AT >rom         /* "VMA AT LMA */


    .stack (NOLOAD) :
    {
        . = ALIGN(4);
        . = . + STACK_SIZE;
        . = ALIGN(4);
    } > ram




}
