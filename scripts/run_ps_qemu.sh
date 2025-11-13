#!/bin/bash
i=0
while true
do
   echo "run ps"
   ps -ef | grep qemu | tee -a ps_qemu.out
   du -a /run/vc/vm | grep sock
   sleep 0.5
done
