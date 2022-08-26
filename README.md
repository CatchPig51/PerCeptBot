# Percept Bot
Percept Bot是基于k210+esp32的社交机器人，Percept Bot项目将会模拟一种一个有"生命力"的人在一个有"生命力"的环境下生活的这种关系。Percept Bot将拟合具有"生命力"的一般形式表现和基于神经网络模型的"智商"和"情商"。

演示地址:https://www.bilibili.com/video/BV1kU4y1i7sf

## 完成情况

Percept Bot项目将分为以下三个部分:

| 设备端 | 功能 |
| ---- | ---- |
| 边缘端 | 模拟"生老病死"和"喜怒哀乐"以及学习能力 |
| 手机端 | 作为边缘端和服务器端的交互模块 |
| 服务器端 | 生成一个世界模型 |

### 边缘端

     [√] TextCnn实现由手机端输入中文判断情感二分类

     [ ] 通过seq2seq框架对输入中文进行文本输出

     [ ] 使用Bert/GPT替代上述框架

     [ ] 通过周期时序映射赋予边缘端"生命力"   

### 手机端

     [√] 通过BLE与边缘端通信

     [ ] 通过Beego V2与服务器端通信

     [ ] ....待定

### 服务器端

     [ ] 部署预训练语言模型

     [ ] 通过周期时序映射赋予服务器端"生命力"

     [ ] ....待定

## 如何使用

目前只实现了边缘端和手机端的最基础功能。

- 克隆到您本地目录下。

- 将k210\rtthread.bin通过kflash烧录到您开发板的K210上,烧录成功后您将看到表情的GUI运行。

- 将BLE\src\main.cpp通过PlatformIO烧录到ESP32上,ESP32将开启蓝牙相应状态。

- 安装dart&flutter环境,通过run命令执行将得到一个安装包,您将看到APP的运行界面。

## 注解

"生命力"这种概念和功能实现将在论文写完后移植到本项目中。
