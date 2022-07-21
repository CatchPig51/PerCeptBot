/*
 * Copyright (c) 2006-2021, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2019-03-07     ZYH          first version
 */

#ifndef DRV_LCD_H__
#define DRV_LCD_H__

#include <rtdevice.h>
#include "drv_lcd.h"
#include <board.h>
#include <gpiohs.h>
#include <spi.h>
#include <drv_io_config.h>
#include <rthw.h>
#include "dmalock.h"
#include "sleep.h"

int rt_hw_lcd_init(void);

//POINT_COLOR
#define WHITE 0xFFFF
#define BLACK 0x0000
#define BLUE 0x001F
#define BRED 0XF81F
#define GRED 0XFFE0
#define GBLUE 0X07FF
#define RED 0xF800
#define MAGENTA 0xF81F
#define GREEN 0x07E0
#define CYAN 0x7FFF
#define YELLOW 0xFFE0
#define BROWN 0XBC40
#define BRRED 0XFC07
#define GRAY 0X8430
#define GRAY175 0XAD75
#define GRAY151 0X94B2
#define GRAY187 0XBDD7
#define GRAY240 0XF79E

typedef struct lcd_8080_device
{
    struct rt_device parent;
    struct rt_device_graphic_info lcd_info;
    int spi_channel;
    int cs;
    int dc_pin;
#if BSP_LCD_RST_PIN >= 0
    int rst_pin;
#endif
#if BSP_LCD_BACKLIGHT_PIN >= 0
    int backlight_pin;
#endif
    int dma_channel;
} * lcd_8080_device_t;

typedef enum _lcd_dir
{
    DIR_XY_RLUD = 0x00,
    DIR_YX_RLUD = 0x20,
    DIR_XY_LRUD = 0x40,
    DIR_YX_LRUD = 0x60,
    DIR_XY_RLDU = 0x80,
    DIR_YX_RLDU = 0xA0,
    DIR_XY_LRDU = 0xC0,
    DIR_YX_LRDU = 0xE0,
    DIR_XY_MASK = 0x20,
    DIR_MASK = 0xE0,
} lcd_dir_t;

/* for mpy machine.lcd */
void lcd_display_on(void);
void lcd_display_off(void);
void lcd_clear(int color);
void lcd_update(int x, int y, int w, int h);
void lcd_draw_point_color(int x, int y, int color);
void lcd_show_string(int x, int y, int size, const char *data);
void lcd_draw_line(int x1, int y1, int x2, int y2);
void lcd_draw_rectangle(int x1, int y1, int x2, int y2);
void lcd_draw_circle(int x1, int y1, int r);
void lcd_set_color(int back, int fore);
void lcd_show_image(int x, int y, int length, int wide, const unsigned char *buf);
int lcd_init(void);
void lcd_set_direction(lcd_dir_t dir);
void drv_lcd_set_area(lcd_8080_device_t lcd, rt_uint16_t x1, rt_uint16_t y1, rt_uint16_t x2, rt_uint16_t y2);
void drv_lcd_data_half_word(lcd_8080_device_t lcd, rt_uint16_t *data_buf, rt_uint32_t length);

#endif
