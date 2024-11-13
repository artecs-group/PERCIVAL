#!/bin/bash

set -e
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
PATH=$RISCV/bin:/bin:$PATH

cd $ROOT/tmp

echo "Installing RISC-V Proxy Kernel and Boot Loader"
git clone https://github.com/riscv-software-src/riscv-pk.git
cd riscv-pk
git checkout 4ae5a8876fc2c31776b1777405ab14f764cc0f36
mkdir -p build
cd build
../configure --prefix=$RISCV --host=riscv64-unknown-elf --with-arch=rv64gc_zifencei
make
make install
