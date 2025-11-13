#!/bin/bash
#-name sandbox-e6d5aa56a5aa0acc71d10f202a1cf49dafb91626143734009a62831e3e7dac02,debug-threads=on \
#-uuid 5cd0e6c8-652e-469f-86b6-0842f01b3f71 \
#-device vhost-vsock-pci,disable-modern=false,vhostfd=4,id=vsock-2536804889,guest-cid=2536804889,romfile= \
#-netdev tap,id=network-0,vhost=on,vhostfds=5,fds=6 \
#-device driver=virtio-net-pci,netdev=network-0,mac=0a:58:0a:80:00:9d,disable-modern=false,mq=on,vectors=4,romfile= \
#-pidfile /run/vc/vm/e6d5aa56a5aa0acc71d10f202a1cf49dafb91626143734009a62831e3e7dac02/pid \
#-qmp unix:fd=3,server=on,wait=off \
#/var/home/core/kata_qemu_rhel9/opt/kata/bin/qemu-system-x86_64 \

/usr/libexec/qemu-kvm \
--enable-kvm \
-machine q35,accel=kvm,kernel_irqchip=split,confidential-guest-support=snp \
-cpu EPYC-v4,pmu=off \
-m 2048M,slots=10,maxmem=514748M \
-device pci-bridge,bus=pcie.0,id=pci-bridge-0,chassis_nr=1,shpc=off,addr=2,romfile=,io-reserve=4k,mem-reserve=1m,pref64-reserve=1m \
-device virtio-serial-pci,disable-modern=false,id=serial0 \
-device virtconsole,chardev=charconsole0,id=console0 \
-chardev socket,id=charconsole0,path=/var/home/core/console.sock,server=on,wait=off \
-device virtio-scsi-pci,id=scsi0,disable-modern=false,romfile= \
-object sev-snp-guest,id=snp,cbitpos=51,reduced-phys-bits=1,kernel-hashes=on \
-object rng-random,id=rng0,filename=/dev/urandom \
-device virtio-rng-pci,rng=rng0,romfile= \
-rtc base=utc,driftfix=slew,clock=host \
-global kvm-pit.lost_tick_policy=discard \
-vga none -no-user-config -nodefaults -nographic --no-reboot \
-object memory-backend-ram,id=dimm1,size=2048M \
-numa node,memdev=dimm1 \
-kernel /usr/kata/share/kata-containers/vmlinuz-6.7-136-confidential \
-initrd /usr/kata/share/kata-containers/kata-ubuntu-20.04-confidential.initrd \
-append "tsc=reliable no_timer_check rcupdate.rcu_expedited=1 i8042.direct=1 i8042.dumbkbd=1 i8042.nopnp=1 i8042.noaux=1 noreplace-smp reboot=k cryptomgr.notests net.ifnames=0 pci=lastbus=0 console=hvc0 console=hvc1 debug panic=1 nr_cpus=1 selinux=0 scsi_mod.scan=none agent.log=debug agent.debug_console agent.debug_console_vport=1026 console=ttyS0" \
-bios /usr/share/edk2/ovmf/OVMF.amdsev.fd \
-serial file:/var/home/core/qemu.log \
--trace "kvm_sev*" \
-D /var/home/core/qemu-trace.log \
-global isa-debugcon.iobase=0x402 \
-smp 1,cores=1,threads=1,sockets=1,maxcpus=1
