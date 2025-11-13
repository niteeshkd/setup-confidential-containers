#!/bin/fish
if test (count $argv) -le 0
    set num 1
else
    set num $argv
end

test $num -le 0 && exit 1
set counter 0
while test $counter -lt $num;
    busybox echo "busybox time bzip2 /tmp/file1G"
    busybox date +"%T"
    busybox time bzip2 /tmp/file1G
    busybox echo "busybox time bunzip2 /tmp/file1G.bz2"
    busybox date +"%T"
    busybox time bunzip2 /tmp/file1G.bz2
    set counter (math $counter + 1)
end
busybox date +"%T"
