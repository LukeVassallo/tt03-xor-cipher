#!/bin/bash

mkdir tools && cd tools

#yosys
git clone https://github.com/YosysHQ/yosys && cd yosys
make config-gcc 
make -j$(nproc)
make test 
cd ../

#icestorm
git clone https://github.com/YosysHQ/icestorm.git icestorm && cd icestorm
make -j$(nproc)
make install PREFIX=${PWD}
cd ../

#cmake
mkdir cmake && cd cmake
wget https://github.com/Kitware/CMake/releases/download/v3.26.0-rc1/cmake-3.26.0-rc1.tar.gz # Check for latest release
tar -xf ./cmake-3.26.0-rc1.tar.gz && cd cmake-3.26.0-rc1
./bootstrap
make -j$(nproc)
cd ../../

#nextpnr
git clone https://github.com/YosysHQ/nextpnr && cd nextpnr
../cmake/cmake-3.26.0-rc1/bin/cmake . -DARCH=ice40 -DICESTORM_INSTALL_PREFIX=$PWD/../icestorm
make -j$(nproc)
cd ../

cd ../

#export PATH=$PATH:$PWD/yosys:$PWD/nextpnr:$PWD/icestorm/bin
echo "PATH=\$PATH:$PWD/tools/yosys:$PWD/tools/nextpnr:$PWD/tools/icestorm/bin" > env_setup.sh
chmod +x ./env_setup.sh

echo ""
echo "Toolchain build complete."
echo "Before building the projects place the tools on \$PATH by calling 'source env_setup.sh'" 
