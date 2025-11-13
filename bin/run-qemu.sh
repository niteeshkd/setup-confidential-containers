#!/bin/bash
#Source https://gist.github.com/marcov/2acd70af566ea276c222591fa88223a4

[ -f "$kataKernel" ] || { echo "Need to export a valid kataKernel path"; sleep 10; }

if [ -f "$kataImage" ]; then
	[ -f "$kataInitrd" ] && { echo "Cant specify both kataImage and kataInitrd"; sleep 10; }
	kataImageSize="$(wc -c ${kataImage} | cut -d " " -f 1)"
	rootfsDevice="-device nvdimm,id=nv0,memdev=mem0"
	rootfsObject="-object memory-backend-file,id=mem0,mem-path=${kataImage},size=${kataImageSize}"
	rootfsCmdline="root=/dev/pmem0p1 rootflags=dax,data=ordered,errors=remount-ro rw rootfstype=ext4"

elif [ -f "$kataInitrd" ]; then
	initrdOption="-initrd ${kataInitrd}"
else
	{ echo "Need to export a valid kataImage XOR kataInitrd path"; sleep 10; }

fi

declare -a qemuDevices=(
	-device pci-bridge,bus=pci.0,id=pci-bridge-0,chassis_nr=1,shpc=on,addr=2,romfile= \
	-device virtio-serial-pci,id=serial0,romfile= \
	-device virtio-scsi-pci,id=scsi0,romfile= \
	-device driver=virtio-net-pci,id=network-0,netdev=network-0,mac=02:42:ac:11:00:02,disable-modern=false,mq=on,vectors=4,romfile= \
	-device virtio-rng,rng=rng0,romfile= \
	${rootfsDevice} \
)


 # systemd.unit=kata-containers.target \

systemdCmdline=" \
 systemd.show_status=true \
 systemd.log_level=debug  \
 systemd.mask=systemd-networkd.service \
 systemd.mask=systemd-networkd.socket \
 systemd.mask=systemd-journald.service \
 systemd.mask=systemd-journald.socket \
 systemd.mask=systemd-journal-flush.service \
 systemd.mask=systemd-journald-dev-log.socket \
 systemd.mask=systemd-udevd.service \
 systemd.mask=systemd-udevd.socket \
 systemd.mask=systemd-udev-trigger.service \
 systemd.mask=systemd-udevd-kernel.socket \
 systemd.mask=systemd-udevd-control.socket \
 systemd.mask=systemd-timesyncd.service \
 systemd.mask=systemd-update-utmp.service \
 systemd.mask=systemd-tmpfiles-setup.service \
 systemd.mask=systemd-tmpfiles-cleanup.service \
 systemd.mask=systemd-tmpfiles-cleanup.timer \
 systemd.mask=systemd-random-seed.service \
 systemd.mask=systemd-coredump@.service"

# This will start a shell on ttyS0
shellCmdline="systemd.unit=getty@ttyS0.service"

cmdlineDebug="debug systemd.debug_shell systemd.log_level=debug rd.shell rd.break=pre-mount rd.debug"

kernelCmdline=" \
  tsc=reliable \
  no_timer_check \
  rcupdate.rcu_expedited=1 \
  i8042.direct=1 \
  i8042.dumbkbd=1 \
  i8042.nopnp=1 \
  i8042.noaux=1 \
  noreplace-smp \
  reboot=k \
  console=ttyS0 \
  console=hvc1 \
  iommu=off \
  cryptomgr.notests \
  net.ifnames=0 \
  pci=lastbus=0 \
  systemd.show_status=true \
  panic=1 \
  nr_cpus=4 \
  ${shellCmdline} \
  ${systemdCmdline} \
  ${cmdlineDebug}"

declare -a qemuOptions=( \
	-machine pc,accel=kvm,kernel_irqchip=split \
	-cpu host \
	-m 2048M,slots=10,maxmem=4096M \
	-object rng-random,id=rng0,filename=/dev/urandom
	-netdev user,id=network-0
	-global kvm-pit.lost_tick_policy=discard \
	-vga none -no-user-config -nodefaults -nographic \
	${qemuDevices[@]} \
	${rootfsObject} \
	${rootfsAppend[@]} \
	${initrdOption} \
	-kernel ${kataKernel} \
	-serial mon:stdio \
)

#sudo qemu-system-x86_64 ${qemuOptions[@]} -append "$kernelCmdline $rootfsCmdline"
sudo ${QEMU} ${qemuOptions[@]} -append "$kernelCmdline $rootfsCmdline"

sleep 10
