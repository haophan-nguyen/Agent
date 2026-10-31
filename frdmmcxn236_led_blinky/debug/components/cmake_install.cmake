# Install script for directory: D:/work_space/NXP/SDK/frdm_mcxn236/mcuxsdk/components

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/frdmmcxn236_led_blinky")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "C:/Users/LENOVO/.mcuxpressotools/arm-gnu-toolchain-14.2.rel1-mingw-w64-x86_64-arm-none-eabi/bin/arm-none-eabi-objdump.exe")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/assert/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/audio/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/aws_iot/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/button/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/common_task/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/coremark/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/crc/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/debug_console/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/debug_console_lite/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/display/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/exception_handling/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/flash/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/gpio/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/i2c/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/internal_flash/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/led/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/lists/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/log/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/mem_manager/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/messaging/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/misc_utilities/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/osa/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/panic/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/pmic/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/power_manager/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/pwm/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/reset/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/reset1/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/rng/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/rpmsg/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/rtc/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/sensor/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/serial_manager/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/shell/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/spi/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/str/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/timer/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/timer_manager/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/time_stamp/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/touch/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/uart/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/video/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/phy/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/IS42SM16800H/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/adc_sensor/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/conn_fwloader/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/ele_crypto/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/v2x_base/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/v2x_fce/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/i3c_bus/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/imx_sm_crc/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/imu_adapter/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/mt48lc2m32b2/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/mt48lc4m16a2/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/mx25_flash/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/mx25l_flash/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/mx25r_flash/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/rtt/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/scmi/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/sdu/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/slcd_engine/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/smt/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/srtm/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/sx1502/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/wifi_bt_module/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/smbus/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/debug_console_rtt/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/semihost/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/notifier/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/ele_base_api/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/format/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/mpi_loader/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/pinctrl/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/clock/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/silicon_id/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/sm/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/systick_timer/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/timer_lptmr/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/unity/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/power/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/codec/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/expander/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/edgefast_wifi/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/eeprom_emulation/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/eeprom_emulation_k4/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/storage/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/debug/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/gen_hal/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/lce/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_dspi/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_ecspi/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_enet/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_enet_phy/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_flexcomm/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_gpio/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_i2c/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_ii2c/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_iuart/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_lpc_gpio/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_lpc_i2c/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_lpc_vspi/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_lpc_vusart/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_lpi2c/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_lpsci/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_lpspi/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_lpuart/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_mcx_enet/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_mcx_flash/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_spi/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("D:/work_space/Agent/Agent/frdmmcxn236_led_blinky/debug/components/cmsis_drivers/cmsis_uart/cmake_install.cmake")
endif()

