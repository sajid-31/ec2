#!/bin/bash
sudo apt update && sudo apt install -y \
    git cmake build-essential \
    libboost-all-dev \
    libopencv-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    freeglut3-dev \
    libglew-dev \
    libatlas-base-dev \
    libsuitesparse-dev \
    wget

# Clone COLMAP
git clone https://github.com/colmap/colmap.git
cd colmap
git checkout dev

# Build COLMAP
mkdir build && cd build
cmake ..
make -j$(nproc)
sudo make install
