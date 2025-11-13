#!/usr/bin/env bash
/usr/libexec/qemu-kvm \
-debugcon file:/var/home/core/debug_qemufw.log -global isa-debugcon.iobase=0x402 \
-serial file:/var/home/core/debug_serial.log \
"$@"
