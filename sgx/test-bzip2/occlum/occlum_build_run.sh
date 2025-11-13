#! /bin/bash
set -e

bomfile="../copy.yaml"

rm -rf occlum_instance
occlum new occlum_instance

pushd occlum_instance
rm -rf image
copy_bom -f $bomfile --root image --include-dir /opt/occlum/etc/template

occlum build
#occlum run /bin/fish -c "time /bin/busybox bzip2 /tmp/file1G"
#occlum run /bin/fish -c "/bin/busybox time bzip2 /tmp/file1G"
#occlum run /bin/test-bzip2.sh
occlum run /bin/test-bzip2unzip.sh 2
popd
