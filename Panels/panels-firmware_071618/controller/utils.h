#include "ff.h"	
#include "twi.h"
#include <string.h>
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include "uart.h"
#include "timer.h"
#include "xitoa.h"
#include "handler.h"
#include <stdlib.h>

#define testbit(port, bit) (uint8_t)(((uint8_t)port & (uint8_t)_BV(bit)))

#define LED0 0
#define LED1 1
#define LED2 2
#define LED3 3

#define ON 1
#define OFF 0

#define OUTPUT 0
#define INPUT 1
#define LOW 0
#define HIGH 1
#define IHEX_MAXDATA 256
#define PANEL_BL_ADDR 0x70
#define HEADER_SIZE 5
#define PAGE_SIZE 128
#define PAGE_SIZE_SHIFT 7

FIL file5, file6;
static const uint8_t panelFlash[] = "panel.hex\0";
static const uint8_t panelEEprom[] = "panel.eep\0";

TWI_Master_t twi1;    // TWI master module #1
TWI_Master_t twi2;    // TWI master module #2
TWI_Master_t twi3;    // TWI master module #3
TWI_Master_t twi4;    // TWI master module #4

uint8_t  chMap[129];  // panel twi channel mapping

typedef struct ihexrec {
  uint8_t  reclen;
  uint16_t loadofs;
  uint8_t  rectyp;
  uint8_t  data[IHEX_MAXDATA];
  uint8_t  cksum;
}ihexrec_t;

/* Routine Prototypes */
void CCPWrite( volatile uint8_t * address, uint8_t value );
void ledWrite( uint8_t led, uint8_t value );
void ledToggle( uint8_t led );
void ledBlink(void);
void digitalMode( uint8_t bit, uint8_t mode);
uint8_t digitalRead( uint8_t bit );
void digitalWrite( uint8_t bit, uint8_t value );
void digitalToggle( uint8_t bit );
int16_t analogRead( uint8_t ch );
void analogWrite(uint8_t ch, int16_t value);
void test_DIO(uint8_t ch);
void SystemReset(void);
void test_ADC(uint8_t ch);
void eeprom_panel(uint8_t panel_num);
void flash_panel(uint8_t panel_num);

static
int16_t ihex_readrec(ihexrec_t * ihex, char * rec);

static
void put_rc (FRESULT rc);

void progPage(TWI_Master_t *twi, uint32_t paddr, uint8_t psize, uint8_t *buff);
void readPage(TWI_Master_t *twi, uint32_t paddr, uint8_t psize, uint8_t *buff);


int verifyPage(TWI_Master_t *twi, uint32_t paddr, uint8_t psize, uint8_t *buff);

void progEEPage(TWI_Master_t *twi, uint32_t paddr, uint8_t psize, uint8_t *buff);
void readEEPage(TWI_Master_t *twi, uint32_t paddr, uint8_t psize, uint8_t *buff);
int verifyEEPage(TWI_Master_t *twi, uint32_t paddr, uint8_t psize, uint8_t *buff);