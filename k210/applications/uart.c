#include <rtthread.h>
#include "cpu_usage.h"

#define SAMPLE_UART_NAME                 "uart1"
#define DATA_CMD_END                     '\r'       
#define ONE_DATA_MAXLEN                  128         

/* 用于接收消息的信号量 */
static struct rt_semaphore rx_sem;
rt_device_t serial;
static rt_thread_t thread;

extern int writecons;

/* 接收数据回调函数 */
static rt_err_t uart_rx_ind(rt_device_t dev, rt_size_t size)
{
   
    if (size > 0)
    {
        rt_sem_release(&rx_sem);
    }
    return RT_EOK;
}

static char uart_sample_get_char(void)
{
    char ch;

    while (rt_device_read(serial, 0, &ch, 1) == 0)
    {
        rt_sem_control(&rx_sem, RT_IPC_CMD_RESET, RT_NULL);
        rt_sem_take(&rx_sem, RT_WAITING_FOREVER);
    }
    return ch;
}

/* 数据解析线程 */
static void data_parsing(void)
{
    char ch;
    char data[ONE_DATA_MAXLEN];
    static char i = 0;
    int y=0;

    while (1)
    {
        ch = uart_sample_get_char();

        if(ch ==','){
            y++;
        }
        if(ch == DATA_CMD_END)
        {
            data[i++] = '\0';
            read_data('testa.kmodel',data,y);
            y = 0;
            i = 0;
            continue;
        }
        i = (i >= ONE_DATA_MAXLEN-1) ? ONE_DATA_MAXLEN-1 : i;

        if(ch !='[' && ch !=']'){

            data[i++] = ch;

        }

    }
}

static int uart_data_sample(int argc, char *argv[])
{
    rt_err_t ret = RT_EOK;
    char uart_name[RT_NAME_MAX];
    rt_strncpy(uart_name, SAMPLE_UART_NAME, RT_NAME_MAX);

    /* 查找系统中的串口设备 */
    serial = rt_device_find(uart_name);

    if (!serial)
    {
        rt_kprintf("find %s failed!\n", uart_name);
        return RT_ERROR;
    }


    rt_sem_init(&rx_sem, "rx_sem", 0, RT_IPC_FLAG_FIFO);

    rt_device_open(serial, RT_DEVICE_OFLAG_RDWR | RT_DEVICE_FLAG_INT_RX);

    rt_device_set_rx_indicate(serial, uart_rx_ind);


    thread = rt_thread_create("serial", (void (*)(void *parameter))data_parsing, RT_NULL,92000, 4, 10);

    if (thread != RT_NULL)
    {
        rt_thread_startup(thread);
    }
    else
    {
        ret = RT_ERROR;
    }

    return ret;
}


INIT_DEVICE_EXPORT(uart_data_sample);
