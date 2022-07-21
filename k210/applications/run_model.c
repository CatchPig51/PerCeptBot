/*
 * Copyright (c) 2006-2022, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 */

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dfs_posix.h> 
#include <dfs_fs.h>
#include "utils.h"
#include "kpu.h"
#include <lvgl.h>

volatile uint32_t g_ai_done_flag;
kpu_model_context_t task;
int Chitxt[10]={0,0,0,0,0,0,0,0,0,0};
int result=0;
extern const lv_obj_class_t lv_gif_class;
extern const lv_img_dsc_t Sad_Stats;
extern const lv_img_dsc_t Happy_Stats;
extern const lv_img_dsc_t Normal_Stats;
lv_obj_t * img;


void lv_user_gui_init(void)
{
    LV_IMG_DECLARE(Sad_Stats);
    LV_IMG_DECLARE(Normal_Stats);
    LV_IMG_DECLARE(Happy_Stats);
    img = lv_gif_create(lv_scr_act());
    lv_gif_set_src(img, &Normal_Stats);
    lv_obj_align(img,LV_ALIGN_CENTER, 0, 0);
}

static void ai_done(void *ctx)
{
    g_ai_done_flag = 1;
}

int read_data(char dataloc[30],char* textdataloc,int length)
{
    //float speed ;
    //float speed_time;
    FILE *fp; 
    struct stat buf;
    uint8_t *buffer;
    char *token;
    const char s[2] = ",";
    int i=0;

    token = strtok(textdataloc, s);
    Chitxt[i]  = atoi(token);
    i++;

    while( token != NULL ) {

      token = strtok(NULL, s);

      Chitxt[i] =  atoi(token);
      i++;
   }

    if ((fp = fopen("testa.kmodel", "r")) == NULL)
    {
        rt_kprintf("can not find kmodel file!");
        return NULL;
    }

    stat("testa.kmodel", &buf);

    buffer=(uint8_t *)malloc(buf.st_size);

    //speed =  rt_tick_get();

    while (!feof(fp)) 
    {   
        rt_thread_mdelay(1);
        fread(buffer,sizeof(uint8_t),buf.st_size,fp);
    }
#if 0
    speed = rt_tick_get()-speed;
    speed_time = 10000/speed;
    speed_time = (sizeof(s)*speed_time);

    rt_kprintf("Load kmodel data done. speed：%d kb/s\n",(int)speed_time);
#endif
    if (kpu_load_kmodel(&task,buffer) != 0){

        rt_kprintf("Cannot load kmodel.\n");
        exit(-1);

    }
    free(buffer);
    fclose(fp);


    {
        //float kpu_start_time = rt_tick_get();

        kpu_run_kmodel(&task, (const uint8_t *)Chitxt, DMAC_CHANNEL5, ai_done, NULL);

        memset(Chitxt, 0, 10);

        while(!g_ai_done_flag)
            ;

        //float kpu_end_time = rt_tick_get()-kpu_start_time;
        //printf("kmodel loaded time is :%dms",(int)kpu_end_time);
        float *output;
        size_t output_size;

        kpu_get_output(&task, 0, (uint8_t **)&output, &output_size);
#if 0
        printf("\r\n%f\r\n",output[0]);
        printf("%f\r\n",output[1]);
#endif

        int r=output[0]>output[1]?1:2;
        kpu_model_free(&task);

        result = r; 
        rt_thread_mdelay(3000);
        result = 0;

        return result;
    }
    return 0;
}

/******I DONT'T KNOW HOW USE AS THROW FUNCTION******/


void dispose_stat(void)
{
    lv_gif_destructor(lv_gif_class,img);
}

int read_model_data(char loc[30],char* textloc,int length){

    //read_data("testa.kmodel",textloc,length);

    return 0;
}