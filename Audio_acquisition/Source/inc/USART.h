/* usart.h */
#ifndef USART_H
#define USART_H
#include <stm32f4xx.h> // common stuff
#include <stm32f4xx_rcc.h> // reset anc clocking
#include <stm32f4xx_gpio.h> // gpio control
#include <stm32f4xx_usart.h> // USART
#define BUFSIZE 16
#define BAUDRATE 115200
#define LENGTH 7*20

extern int16_t coeffs[LENGTH];
extern uint8_t offset[5];
extern	uint8_t gain[5];
void USART1_Init(void); // init USART1 peripheral
void uartClose(USART_TypeDef* USARTx);
void uartPutString(volatile char *c, USART_TypeDef* USARTx);
int uartGetc(USART_TypeDef* USARTx);
void uartSendInt(uint8_t *c, USART_TypeDef* USARTx);
int USART1_IRQHandler(void);

#endif