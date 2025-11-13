#!/usr/bin/env bash
#/data/niteesh/github/qemu_build/qemu-system-x86_64 \
#/data/niteesh/github/kata-containers/tools/packaging/kata-deploy/local-build/build/qemu/destdir/opt/kata/bin/qemu-system-x86_64 \
/opt/kata/bin/qemu-system-x86_64-snp-experimental \
-debugcon file:/tmp/debug.log -global isa-debugcon.iobase=0x402 \
-serial file:/tmp/serial.log \
"$@"
