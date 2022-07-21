CMAKE_MINIMUM_REQUIRED(VERSION 3.10)

SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_PROCESSOR k210)
#SET(CMAKE_VERBOSE_MAKEFILE ON)

SET(CMAKE_EXPORT_COMPILE_COMMANDS ON)

SET(CMAKE_C_COMPILER "E:/rt-thread-env/riscv_gcc/bin/riscv-none-embed-gcc.exe")
SET(CMAKE_ASM_COMPILER "E:/rt-thread-env/riscv_gcc/bin/riscv-none-embed-gcc.exe")
SET(CMAKE_C_FLAGS " -mcmodel=medany -march=rv64imafc -mabi=lp64f -fsingle-precision-constant -fno-common -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -O2 -Os")
SET(CMAKE_ASM_FLAGS " -c -mcmodel=medany -march=rv64imafc -mabi=lp64f -fsingle-precision-constant -x assembler-with-cpp")
SET(CMAKE_C_COMPILER_WORKS TRUE)

SET(CMAKE_CXX_COMPILER "E:/rt-thread-env/riscv_gcc/bin/riscv-none-embed-g++.exe")
SET(CMAKE_CXX_FLAGS " -mcmodel=medany -march=rv64imafc -mabi=lp64f -fsingle-precision-constant -fno-common -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -O2 -Os -std=gnu++17 -Wno-multichar")
SET(CMAKE_CXX_COMPILER_WORKS TRUE)

SET(CMAKE_OBJCOPY "E:/rt-thread-env/riscv_gcc/bin/riscv-none-embed-objcopy.exe")
SET(CMAKE_SIZE "E:/rt-thread-env/riscv_gcc/bin/riscv-none-embed-size.exe")

SET(CMAKE_EXE_LINKER_FLAGS " -mcmodel=medany -march=rv64imafc -mabi=lp64f -fsingle-precision-constant -nostartfiles -Wl,--gc-sections,-Map=rtthread.map,-cref,-u,_start -T ${CMAKE_SOURCE_DIR}/link.lds")

SET(CMAKE_CXX_STANDARD 14)
PROJECT(rtthread C CXX ASM)
INCLUDE_DIRECTORIES(
	.
	applications
	driver
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/bsp/include
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/include
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/include
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/include
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/include/kernels
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/include/kernels/cpu
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/include/kernels/k210
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/include/kernels/neutral
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/include/kernels/riscv
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/include/runtime
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/include/runtime/cpu
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/include/runtime/k210
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/include/runtime/neutral
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/include/targets
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v1
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v1/include/nncase
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v1/include/nncase/kernels
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v1/include/nncase/kernels/cpu/optimized
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v1/include/nncase/kernels/cpu/reference
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v1/include/nncase/kernels/k210
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v1/include/nncase/kernels/neutral
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v1/include/nncase/kernels/riscv
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v1/include/nncase/runtime
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v1/include/nncase/runtime/k210
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v1/include/nncase/runtime/stackvm
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/utils/include
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/third_party/gsl-lite/include/gsl
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/third_party/xtl/include
	../../components/dfs/filesystems/devfs
	../../components/dfs/filesystems/elmfat
	../../components/dfs/include
	../../components/drivers/include
	../../components/drivers/spi
	../../components/drivers/spi/sfud/inc
	../../components/finsh
	../../components/legacy
	../../components/legacy/dfs
	../../components/libc/compilers/common
	../../components/libc/compilers/newlib
	../../components/libc/cplusplus
	../../components/libc/cplusplus/cpp11/gcc
	../../components/libc/posix/delay
	../../components/libc/posix/io/poll
	../../components/libc/posix/io/stdio
	../../components/libc/posix/ipc
	../../components/libc/posix/pthreads
	../../components/libc/posix/signal
	../../components/utilities/ulog
	../../include
	../../libcpu/risc-v/common
	../../libcpu/risc-v/k210
)

ADD_DEFINITIONS(
	-DHAVE_CCONFIG_H
	-DRT_USING_LIBC
	-DRT_USING_NEWLIB
	-D_POSIX_C_SOURCE=1
	-D__RTTHREAD__
)

SET(PROJECT_SOURCES
	applications/uart.c
	applications/run_model.c
	applications/lcd_test.c
	applications/cpu_usage.c
	applications/mnt.c
	applications/main.c
	../../components/libc/compilers/common/stdlib.c
	../../components/libc/compilers/common/time.c
	../../components/libc/compilers/newlib/syscalls.c
	../../components/libc/cplusplus/cxx_Thread.cpp
	../../components/libc/cplusplus/cxx_crt_init.c
	../../components/libc/cplusplus/cpp11/gcc/utils.cpp
	../../components/libc/cplusplus/cxx_crt.cpp
	../../components/libc/cplusplus/cxx_Mutex.cpp
	../../components/libc/cplusplus/cpp11/thread_local_impl.cpp
	../../components/libc/cplusplus/cpp11/gcc/thread.cpp
	../../components/libc/cplusplus/cpp11/gcc/condition_variable.cpp
	../../components/libc/cplusplus/cpp11/gcc/mutex.cpp
	../../components/libc/cplusplus/cpp11/atomic_8.c
	../../components/libc/cplusplus/cpp11/emutls.c
	../../components/libc/cplusplus/cxx_Semaphore.cpp
	../../libcpu/risc-v/common/context_gcc.S
	../../libcpu/risc-v/common/cpuport.c
	../../libcpu/risc-v/k210/cpuport_smp.c
	../../libcpu/risc-v/k210/interrupt.c
	../../libcpu/risc-v/k210/interrupt_gcc.S
	../../libcpu/risc-v/k210/startup_gcc.S
	../../libcpu/risc-v/k210/tick.c
	../../components/drivers/ipc/completion.c
	../../components/drivers/ipc/dataqueue.c
	../../components/drivers/ipc/pipe.c
	../../components/drivers/ipc/ringblk_buf.c
	../../components/drivers/ipc/ringbuffer.c
	../../components/drivers/ipc/waitqueue.c
	../../components/drivers/ipc/workqueue.c
	../../components/drivers/misc/pin.c
	../../components/drivers/rtc/rtc.c
	../../components/drivers/serial/serial.c
	../../components/drivers/spi/sfud/src/sfud.c
	../../components/drivers/spi/sfud/src/sfud_sfdp.c
	../../components/drivers/spi/spi_core.c
	../../components/drivers/spi/spi_dev.c
	../../components/drivers/spi/spi_flash_sfud.c
	../../components/drivers/spi/spi_msd.c
	driver/drv_gpio.c
	driver/drv_uart.c
	driver/drv_spi.c
	driver/heap.c
	driver/board.c
	driver/dmalock.c
	driver/drv_lcd.c
	driver/drv_interrupt.c
	driver/drv_io_config.c
	driver/drv_mpylcd.c
	../../components/dfs/filesystems/devfs/devfs.c
	../../components/dfs/filesystems/elmfat/dfs_elm.c
	../../components/dfs/filesystems/elmfat/ff.c
	../../components/dfs/filesystems/elmfat/ffunicode.c
	../../components/dfs/src/dfs.c
	../../components/dfs/src/dfs_file.c
	../../components/dfs/src/dfs_fs.c
	../../components/dfs/src/dfs_posix.c
	../../components/finsh/shell.c
	../../components/finsh/msh.c
	../../components/finsh/msh_file.c
	../../components/finsh/cmd.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/aes.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/clint.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/nncase_v0.cpp
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/uart.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/utils.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/apu.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v1/nncase_v1.cpp
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/bsp/locks.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/i2s.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/bsp/entry_user.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/spi.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/fpioa.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/sysctl.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/fft.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/runtime/k210/interpreter.cpp
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/rtc.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/dmac.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/bsp/entry.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/runtime/interpreter.cpp
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/runtime/cpu/cpu_ops.cpp
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/i2c.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/uarths.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/timer.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/runtime/k210/k210_ops.cpp
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/sha256.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/wdt.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/kpu.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/runtime/neutral/neutral_ops.cpp
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/pwm.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/gpio.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/plic.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/v0/runtime/kernel_registry.cpp
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/dvp.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/drivers/gpiohs.c
	packages/kendryte-sdk-v0.5.7/kendryte-standalone-sdk/lib/nncase/nncase.cpp
	../../src/clock.c
	../../src/components.c
	../../src/cpu.c
	../../src/device.c
	../../src/idle.c
	../../src/ipc.c
	../../src/irq.c
	../../src/kservice.c
	../../src/memheap.c
	../../src/mempool.c
	../../src/object.c
	../../src/scheduler.c
	../../src/signal.c
	../../src/slab.c
	../../src/thread.c
	../../src/timer.c
	../../components/legacy/ipc/workqueue_legacy.c
	../../components/libc/posix/delay/delay.c
	../../components/libc/posix/io/stdio/libc.c
	../../components/libc/posix/pthreads/pthread.c
	../../components/libc/posix/pthreads/pthread_attr.c
	../../components/libc/posix/pthreads/pthread_barrier.c
	../../components/libc/posix/pthreads/pthread_cond.c
	../../components/libc/posix/pthreads/pthread_mutex.c
	../../components/libc/posix/pthreads/pthread_rwlock.c
	../../components/libc/posix/pthreads/pthread_spin.c
	../../components/libc/posix/pthreads/pthread_tls.c
	../../components/libc/posix/pthreads/sched.c
	../../components/libc/posix/signal/posix_signal.c
	../../components/utilities/ulog/ulog.c
	../../components/utilities/ulog/backend/console_be.c
)

LINK_DIRECTORIES(
)

LINK_LIBRARIES(
	c
	m
)

ADD_EXECUTABLE(${CMAKE_PROJECT_NAME}.elf ${PROJECT_SOURCES})
ADD_CUSTOM_COMMAND(TARGET ${CMAKE_PROJECT_NAME}.elf POST_BUILD 
COMMAND ${CMAKE_OBJCOPY} -O binary ${CMAKE_PROJECT_NAME}.elf ${CMAKE_PROJECT_NAME}.bin COMMAND ${CMAKE_SIZE} ${CMAKE_PROJECT_NAME}.elf)