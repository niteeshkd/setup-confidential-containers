#!/bin/bash
INSTALL_DIR=/opt/confidential-containers
TEST_KATASHIM=/data/niteesh/github/kata-containers-CCv0/src/runtime/containerd-shim-kata-v2
TEST_CONFIG=/data/niteesh/github/old/setup-confidential-containers/sev_snp/configuration-qemu-snp.toml

if [[ ! -f ${INSTALL_DIR}/bin/containerd-shim-kata-v2.orig ]]
then
    sudo cp ${INSTALL_DIR}/bin/containerd-shim-kata-v2 ${INSTALL_DIR}/bin/containerd-shim-kata-v2.orig
fi
sudo ln -sf $TEST_KATASHIM ${INSTALL_DIR}/bin/containerd-shim-kata-v2

ls -l ${INSTALL_DIR}/bin/containerd-shim-kata-v2


if [[ ! -f ${INSTALL_DIR}/share/defaults/kata-containers/configuration.sev.toml.orig ]]
then
    sudo cp ${INSTALL_DIR}/share/defaults/kata-containers/configuration-qemu-sev.toml ${INSTALL_DIR}/share/defaults/kata-containers/configuration-qemu-sev.toml.orig
fi
sudo ln -sf $TEST_CONFIG ${INSTALL_DIR}/share/defaults/kata-containers/configuration-qemu-sev.toml

ls -l ${INSTALL_DIR}/share/defaults/kata-containers/configuration-qemu-sev.toml
