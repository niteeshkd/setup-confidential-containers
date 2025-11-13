/data/niteesh/github/qemu_build/qemu-system-x86_64 \
-debugcon file:/data/niteesh/cc_setup/debug.log -global isa-debugcon.iobase=0x402 -serial file:/data/niteesh/cc_setup/serial.log \
-name sandbox-abc123 -uuid 213e7767-5d80-49e6-8481-6966b6cff6e9 \
-machine q35,accel=kvm,kernel_irqchip=split,confidential-guest-support=sev -cpu host,pmu=off \
-qmp unix:/tmp/vc/vm/abc123/qmp.sock,server=on,wait=off \
-m 8000M,slots=10,maxmem=257790M \
-device pci-bridge,bus=pcie.0,id=pci-bridge-0,chassis_nr=1,shpc=off,addr=2,io-reserve=4k,mem-reserve=1m,pref64-reserve=1m \
-device virtio-serial-pci,disable-modern=false,id=serial0 \
-device virtconsole,chardev=charconsole0,id=console0 -chardev socket,id=charconsole0,path=/tmp/vc/vm/abc123/console.sock,server=on,wait=off \
-device virtio-scsi-pci,id=scsi0,disable-modern=false \
-object sev-guest,id=sev,cbitpos=51,reduced-phys-bits=5,policy=0 -drive if=pflash,format=raw,readonly=on,file=/data/niteesh/github/edk2/Build/OvmfX64/DEBUG_GCC5/FV/OVMF.fd \
-object rng-random,id=rng0,filename=/dev/urandom -device virtio-rng-pci,rng=rng0 \
#-device vhost-vsock-pci,disable-modern=false,vhostfd=3,id=vsock-3523297629,guest-cid=3523297629 \
-device virtio-9p-pci,disable-modern=false,fsdev=extra-9p-kataShared,mount_tag=kataShared \
-fsdev local,id=extra-9p-kataShared,path=/tmp/kata-containers/shared/sandboxes/abc123/shared,security_model=none,multidevs=remap \
#-netdev tap,id=network-0,vhost=on,vhostfds=4,fds=5 \
#-device driver=virtio-net-pci,netdev=network-0,mac=8a:61:2c:8e:5d:c7,disable-modern=false,mq=on,vectors=4 -rtc base=utc,driftfix=slew,clock=host \
-global kvm-pit.lost_tick_policy=discard -vga none -no-user-config -nodefaults -nographic --no-reboot -daemonize \
-object memory-backend-ram,id=dimm1,size=8000M -numa node,memdev=dimm1 \
-kernel /data/niteesh/github/bin/ccv0-sev/2021-11-17/vmlinuz-5.15.0-rc5+ \
-initrd /data/niteesh/github/bin/ccv0-sev/2021-11-17/kata-containers-initrd.img \
-append tsc=reliable no_timer_check rcupdate.rcu_expedited=1 i8042.direct=1 i8042.dumbkbd=1 i8042.nopnp=1 i8042.noaux=1 noreplace-smp reboot=k console=hvc0 console=hvc1 cryptomgr.notests net.ifnames=0 pci=lastbus=0 debug panic=1 nr_cpus=1 scsi_mod.scan=none agent.log=debug agent.debug_console agent.debug_console_vport=1026 agent.config_file=/etc/agent-config.toml \
-pidfile /tmp/vc/vm/abc123/pid \
-D /tmp/vc/vm/abc123/qemu.log \
-smp 1,cores=1,threads=1,sockets=1,maxcpus=1
