#!/bin/bash
#-drive if=pflash,format=raw,unit=0,file=/var/home/core/create_snp_vm/images/OVMF.fd,readonly=on \
#-netdev user,id=netdev1,hostfwd=tcp::1001-:22 -device e1000,netdev=netdev1,disable-legacy=on,iommu_platform=true,romfile= \
/usr/libexec/qemu-kvm \
-name guest=vm1 -smp 4 -accel kvm -nographic -vga none -machine q35 -cpu EPYC-v4 \
-m 4G -object memory-backend-memfd,id=mem1,share=true,size=4G,prealloc=false \
-device virtio-scsi-pci,id=scsi,disable-legacy=on,iommu_platform=true \
-drive file=/var/home/core/create_snp_vm/images/disk1.img,if=none,id=disk0 -device scsi-hd,drive=disk0 \
-drive file=/var/home/core/create_snp_vm/images/nocloud1.iso,if=none,id=disk1,format=raw -device scsi-hd,drive=disk1 \
-netdev user,id=netdev1,hostfwd=tcp::1001-:22 -device virtio-net,netdev=netdev1,iommu_platform=true,romfile= \
-object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,kernel-hashes=on -machine memory-encryption=sev0,vmport=off,memory-backend=mem1 \
-bios /usr/share/edk2/ovmf/OVMF.amdsev.fd \
-debugcon file:/var/home/core/create_snp_vm/images/tmp/debug1.log -global isa-debugcon.iobase=0x402 \
-kernel /var/home/core/create_snp_vm/images/vmlinuz-6.7.0-snp-guest-98543c2aa \
-initrd /var/home/core/create_snp_vm/images/initrd.img-6.7.0-snp-guest-98543c2aa \
-append "root=/dev/sda1 console=ttyS0"
