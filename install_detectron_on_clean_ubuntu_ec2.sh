set -e

## Install dotfiles
## ================
git clone https://github.com/noamyairTC/dotfiles.git
cd dotfiles/
./bringup.sh
echo "Done installing dotfiles." 

## Move to setup folder
## ====================
# mkdir setup
# cd setup

## Install Nvidia drivers
## ======================
wget http://us.download.nvidia.com/tesla/384.145/NVIDIA-Linux-x86_64-384.145.run
sudo sh ./NVIDIA-Linux-x86_64-384.145.run
echo "Done installing Nvidia drivers."

## Installing CUDA drivers
## =======================
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run
sudo sh cuda_9.0.176_384.81_linux.run

wget https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/1/cuda_9.0.176.1_linux.run
sudo sh cuda_9.0.176.1_linux.run --accept-eula

wget https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/2/cuda_9.0.176.2_linux.run
sudo sh cuda_9.0.176.2_linux.run --accept-eula

wget https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/3/cuda_9.0.176.3_linux.run
sudo sh cuda_9.0.176.3_linux.run --accept-eula

wget https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/4/cuda_9.0.176.4_linux.run
sudo sh cuda_9.0.176.4_linux.run --accept-eula
echo "Done installing CUDA drivers."

echo "\n" >> ~/.bashrc
echo "## Added by installation script" >> ~/.bashrc
echo "## ============================" >> ~/.bashrc
echo "export PATH=/usr/local/cuda-9.0/bin${PATH:+:${PATH}}" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc

echo "\n" >> ~/.zshrc
echo "## Added by installation script" >> ~/.zshrc
echo "## ============================" >> ~/.zshrc
echo "export PATH=/usr/local/cuda-9.0/bin${PATH:+:${PATH}}" >> ~/.zshrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.zshrc

## To improve performance
echo "/usr/bin/nvidia-persistenced --verbose" >> ~/.bashrc
echo "/usr/bin/nvidia-persistenced --verbose" >> ~/.zshrc

## installing CUDNN drivers
## ========================
## Replace the link below with the link retrieved from https://developer.nvidia.com/rdp/cudnn-download under version 7.1.2 for cuda 9.0
wget https://developer.download.nvidia.com/compute/machine-learning/cudnn/secure/v7.1.2/prod/9.0_20180316/cudnn-9.0-linux-ppc64le-v7.1.tgz?H_JJWAnqOSOwDJIhgmMXYZEDW0E7mCKdJBnvmhIyKtRKHfjo7rrg18Y0hAr_oKvNR3w9I7HSHOk-AhzALwMQN_D0c0ENjA-TmIPmnhpYYLyNrA_ILNQZng9-Ll70L_n4_7chMnwgMueY2Qe-Q5cyxVBCyiUc9rsKrjlSgUQurYfMqdud8Y89zB4_gx7PKFipccF1ccGH_kCqbPOu3AU
    -O cudnn-9.0-linux-ppc64le-v7.1.tgz
tar -xzvf cudnn-9.0-linux-ppc64le-v7.1.tgz
sudo cp cuda/targets/ppc64le-linux/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/targets/ppc64le-linux/lib/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
echo "Done installing cuDNN drivers."

## Install Caffe dependencies
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libgoogle-glog-dev \
    libgtest-dev \
    libiomp-dev \
    libleveldb-dev \
    liblmdb-dev \
    libopencv-dev \
    libopenmpi-dev \
    libsnappy-dev \
    libprotobuf-dev \
    openmpi-bin \
    openmpi-doc \
    protobuf-compiler \
    python3-dev \
    python3-pip                          
pip3 install --user \
    future \
    numpy \
    protobuf
sudo apt-get install -y --no-install-recommends libgflags-dev

## Install torch
git clone https://github.com/pytorch/pytorch.git && cd pytorch
git submodule update --init --recursive
sudo python3 setup.py install
echo "Done installing Caffe2/Pytorch."

echo "## Added by installation script - End" >> ~/.bashrc
echo "## Added by installation script - End" >> ~/.zshrc
