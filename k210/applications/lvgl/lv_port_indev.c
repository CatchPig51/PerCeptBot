#include <lvgl.h>
#include <rtdevice.h>
#include <drv_gpio.h>


lv_indev_t * button_indev;

//maixduino does not need button so that only init basic

void lv_port_indev_init(void)
{
    static lv_indev_drv_t indev_drv;
    /*assign buttons to coordinates*/

    lv_indev_drv_init(&indev_drv);      /*Basic initialization*/

    /*Register the driver in LVGL and save the created input device object*/
    button_indev = lv_indev_drv_register(&indev_drv);

}