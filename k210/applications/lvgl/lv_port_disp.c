#include <lvgl.h>
#include <rtdef.h>
#include <drv_lcd.h>

#define LCD_W 320
#define LCD_H 240

#define DISP_BUF_SIZE        (LCD_W * LCD_H / 4)

static rt_device_t device;
/*A static or global variable to store the buffers*/
static lv_disp_draw_buf_t disp_buf;

/*Descriptor of a display driver*/
static lv_disp_drv_t disp_drv;


static lcd_8080_device_t x;


/*Static or global buffer(s). The second buffer is optional*/


static struct rt_device_graphic_info info;

/*Flush the content of the internal buffer the specific area on the display
 *You can use DMA or any hardware acceleration to do this operation in the background but
 *'lv_disp_flush_ready()' has to be called when finished.*/
void disp_flush(lv_disp_drv_t * disp_drv, const lv_area_t * area, lv_color_t * color_p)
{   
    /* color_p is a buffer pointer; the buffer is provided by LVGL */
    uint32_t w = (area->x2 - area->x1 + 1);
    uint32_t h = (area->y2 - area->y1 + 1);

    drv_lcd_set_area(x,area->x1, area->y1, area->x2, area->y2);
    drv_lcd_data_half_word(x,&color_p->full, w * h);

    /*IMPORTANT!!!
     *Inform the graphics library that you are ready with the flushing*/
    lv_disp_flush_ready(disp_drv);
}

void lv_port_disp_init(void)
{
    rt_device_t dev;
    
    static lv_color_t  lv_disp_buf1[DISP_BUF_SIZE]= {0};

    dev = rt_device_find("lcd");
    if (!dev)
    {
        rt_kprintf("lcd: %s not found\n", dev);
        return -1;
    }

    if (rt_device_open(dev, RT_DEVICE_OFLAG_RDWR) == RT_EOK)
    {
        rt_device_control(dev, RTGRAPHIC_CTRL_GET_INFO, &info);
    }


    /*Initialize `disp_buf` with the buffer(s). With only one buffer use NULL instead buf_2 */
    lv_disp_draw_buf_init(&disp_buf, lv_disp_buf1, RT_NULL, DISP_BUF_SIZE);

    lv_disp_drv_init(&disp_drv); /*Basic initialization*/

    /*Set the resolution of the display*/
    disp_drv.hor_res = LCD_W;
    disp_drv.ver_res = LCD_H;

    /*Set a display buffer*/
    disp_drv.draw_buf = &disp_buf;

    /*Used to copy the buffer's content to the display*/
    disp_drv.flush_cb = disp_flush;

    /*Finally register the driver*/
    lv_disp_drv_register(&disp_drv);
}