#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
# 

echo "This script was generated under a different operating system."
echo "Please update the PATH and LD_LIBRARY_PATH variables below, before executing this script"
exit

if [ -z "$PATH" ]; then
  PATH=D:/Vivado_21.2/Vitis/2021.2/bin;D:/Vivado_21.2/Vivado/2021.2/ids_lite/ISE/bin/nt64;D:/Vivado_21.2/Vivado/2021.2/ids_lite/ISE/lib/nt64:D:/Vivado_21.2/Vivado/2021.2/bin
else
  PATH=D:/Vivado_21.2/Vitis/2021.2/bin;D:/Vivado_21.2/Vivado/2021.2/ids_lite/ISE/bin/nt64;D:/Vivado_21.2/Vivado/2021.2/ids_lite/ISE/lib/nt64:D:/Vivado_21.2/Vivado/2021.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='E:/Project/Code/CDC/Multi_Bit/Multi_f2s/Multi_f2s_fifo/multi_f2s_fifo/multi_f2s_fifo.runs/fifo_generator_0_synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log fifo_generator_0.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source fifo_generator_0.tcl
