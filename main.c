/* BB2022 */
#define PERIPH_BASE                 0x40000000 
#define APBPERIPH_BASE              PERIPH_BASE
#define AHBPERIPH_BASE              (PERIPH_BASE + 0x00020000)
#define AHB2PERIPH_BASE             (PERIPH_BASE + 0x08000000)

/******* RCC struct defined on this address  ***********/
#define RCC_BASE                    (AHBPERIPH_BASE + 0x00001000) // 0x40021000
// CR offset from RCC_BASE
#define RCC_CR          0x00 
// Bit definitions 
#define  RCC_CR_HSEON               0x00010000        /*!< External High Speed clock enable */
#define  RCC_CR_HSERDY              0x00020000        /*!< External High Speed clock ready flag */
// CFGR offset from RCC_BASE
#define RCC_CFGR        0x04 
// Bit definitions
#define  RCC_CFGR_SW                0x00000003        /*!< SW[1:0] bits (System clock Switch) */
#define  RCC_CFGR_SW_0              0x00000001        /*!< Bit 0 */
#define  RCC_CFGR_SW_1              0x00000002        /*!< Bit 1 */
#define  RCC_CFGR_SWS               0x0000000C        /*!< SWS[1:0] bits (System Clock Switch Status) */
#define  RCC_CFGR_SWS_0             0x00000004        /*!< Bit 0 */
#define  RCC_CFGR_SWS_1             0x00000008        /*!< Bit 1 */
#define  RCC_CFGR_SWS_HSI           0x00000000        /*!< HSI oscillator used as system clock */
#define  RCC_CFGR_SWS_HSE           0x00000004        /*!< HSE oscillator used as system clock */
#define  RCC_CFGR_SWS_PLL           0x00000008        /*!< PLL used as system clock */
// AHBENR offset from RCC_BASE
#define RCC_AHBENR      0x14 // 
//bit definitions 
#define  RCC_AHBENR_GPIOAEN         0x00020000        /*!< GPIOA clock enable */

/*********** GPIOA struct defined on this address  *******/
#define GPIOA_BASE            (AHB2PERIPH_BASE + 0x00000000)
// MODER offset from GPIOX_BASE
#define GPIO_MODER      0x00
// OTYPER offset from GPIOX_BASE
#define GPIO_OTYPER     0x04
// OSPPEDR offet from GPIOX_BASE
#define GPIO_OSPEEDR    0x08
// PUPDR offset from GPIOX_BASE
#define GPIO_PUPDR      0x0C
// BSRR offset from GPIOX_BASE
#define GPIO_BSRR       0x18


void PUT32 ( unsigned int, unsigned int );
unsigned int GET32 ( unsigned int );
void DUMMY ( unsigned int );
void blinker ( unsigned int n )
{
    unsigned int i,j = 0;
    while(j++ < n){
        i  = 200000;
        PUT32((GPIOA_BASE | GPIO_BSRR), 1<<4);    // write bit 13 (BS13 bit-set) in BSRR
        while(i--) DUMMY(i);                   // dummy delay

        i = 200000;
        PUT32((GPIOA_BASE | GPIO_BSRR), 1<<20);     // write bit 29 (BR13 bit-reset) in BSSR
        while(i--) DUMMY(i);                    // dummy delay
    }
}



unsigned int ra; 

int main ( void )
{

    // variables defined here go to stack and are not visible in dissasembly

    /*******************************************************/
    /**************** BLINKER WITH HSE *********************/
    /*******************************************************/

    // turn on High Speed External oscillator (8Mhz xtal)
    ra = GET32(RCC_BASE | RCC_CR);                              // get register (ldr r0,[r0], bx lr)
    ra |= 1 << 16;                                              // set bit 16 (HSEON)
    PUT32((RCC_BASE | RCC_CR),ra);                              // put back modified value (str r1,   [r0], bx lr)
    while(1) if(GET32(RCC_BASE | RCC_CR) & (1<<17)) break;      // wait for ready flag (bit 17 HSERDY)
    
    // select HSE as system clock
    ra = GET32(RCC_BASE | RCC_CFGR);                            // get register 
    ra &= ~(0x3<<0);                                            // clear last two bits (system clock switch)
    ra |= (0x1<<0);                                             // set last bit (01 - HSE selected as system clock)
    PUT32((RCC_BASE |RCC_CFGR),ra);                             // put back modified value 
    while(1) if((GET32(RCC_BASE |RCC_CFGR)&0xF)==0x5) break;    // wait for ready flag

    // enable system clock for port A (GPIOA)
    ra = GET32(RCC_BASE |RCC_AHBENR);                        // get register
    ra |= RCC_AHBENR_GPIOAEN;                                // set bit definition 
    PUT32((RCC_BASE | RCC_AHBENR),ra);                       // put back modified value 


    ra = GET32(GPIOA_BASE | GPIO_MODER);                     // get register 
    ra |= 1 << 8;                                            // PA4 mode is output 
    PUT32(GPIOA_BASE |GPIO_MODER,ra);                         // put back modified value 

    ra = GET32(GPIOA_BASE | GPIO_OTYPER);                      // get register 
    ra |= ra;                                                // already configured           
    PUT32(GPIOA_BASE | GPIO_OTYPER,ra);                        // put back modified value 
     
    ra = GET32(GPIOA_BASE | GPIO_OSPEEDR);                     // get register 
    ra |= ra;                                                // already configured   low speed        
    PUT32(GPIOA_BASE | GPIO_OSPEEDR,ra);                       // put back modified value 

    ra = GET32(GPIOA_BASE+GPIO_PUPDR);                       // get register 
    ra |= ra;                                                // already configured, no pullup pulldow           
    PUT32(GPIOA_BASE+GPIO_PUPDR,ra);                         // put back modified value 


 

    // blink with frequency determined by HSE 
    blinker(5);




    return(0);
}

