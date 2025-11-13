#!/bin/sh
num=$1
[ -z $num ] && num=1
[ $num -le 0 ] && exit 1
counter=0
while [ $counter -lt $num ]
do
    busybox echo "busybox time bzip2 /tmp/file1G"
    busybox date +"%T"
    busybox time bzip2 /tmp/file1G
    busybox echo "busybox time bunzip2 /tmp/file1G.bz2"
    busybox date +"%T"
    busybox time bunzip2 /tmp/file1G.bz2
    counter=$((counter+1))
done
busybox date +"%T"
