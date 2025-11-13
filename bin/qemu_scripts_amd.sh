#!/bin/bash
#echo -e "$@" > /root/test/test.test
#echo -e '\n\n\n' >> /root/test/test.test

#args="$@"
#echo -e "$args" >> /root/test/test.test
#echo -e '\n\n\n' >> /root/test/test.test

#modified_args="$(echo $args | sed 's/"/\\"/g' | sed 's/-daemonize//')"
#echo -e "$modified_args" >> /root/test/test.test
#echo -e '\n\n\n' >> /root/test/test.test

declare -a args

args+=("-global")
args+=("isa-debugcon.iobase=0x402")

args+=("-debugcon")
args+=("file:/root/test/ovmf.log")

args+=("--trace")
args+=("'kvm_sev_*'")

#args+=("-netdev")
#args+=("user,id=vmnic")

#args+=("-vnc")
#args+=(":0")

#args+=("-chardev")
#args+=("stdio,id=char0,mux=on,logfile=/root/test/serial.log,signal=off")

#args+=("-serial")
#args+=("chardev:char0")

#args+=("-mon")
#args+=("chardev=char0")

args+=("-serial")
args+=("file:/root/test/serial.log")

#args+=("-verbose")

append_index=0
n=0

for i in "$@"; do
  let n=n+1
  arg=$i

#  if [[ $append_index -ne 0 ]]; then
#    arg+=" console=ttyAMA0,115200 console=tty highres=off console=ttyS0"
#    append_index=0
#  fi
#  #echo "MEOW001" >> /root/test/log
#  if [[ "$i" == *"-append"* ]]; then
#    append_index=$n
#    #echo "MEOW002: $append_index $n" >> /root/test/log
#  fi
  args+=("$arg")
done

echo -en "${args[@]}" > /root/test/test.test
#exit 1

/usr/bin/qemu-system-x86_64 "${args[@]}"

