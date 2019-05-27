FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
RUN apt-get update
RUN apt-get install -y build-essential \
    checkinstall \
    cmake \
    pkg-config \
    yasm \
    git \
    gfortran \
    libjpeg8-dev libpng-dev \
    libjasper1 \
    libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev \
    libxine2-dev libv4l-dev

RUN cd /usr/include/linux && ln -s -f ../libv4l1-videodev.h videodev.h

RUN apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
    libgtk2.0-dev libtbb-dev qt5-default \
    libatlas-base-dev \
    libfaac-dev libmp3lame-dev libtheora-dev \
    libvorbis-dev libxvidcore-dev \
    libopencore-amrnb-dev libopencore-amrwb-dev \
    libavresample-dev \
    x264 v4l-utils \
    libprotobuf-dev protobuf-compiler \
    libgoogle-glog-dev libgflags-dev \
    libgphoto2-dev libeigen3-dev libhdf5-dev doxygen



RUN apt-get install -y python-dev python-pip python3-dev python3-pip
RUN pip2 install -U pip numpy
RUN pip3 install -U pip numpy

# ---- OPENCV ----

RUN apt-get install libeigen3-dev
ENV CPLUS_INCLUDE_PATH /usr/local/include/eigen3/
RUN cd /home && git clone https://github.com/opencv/opencv.git
RUN cd /home/opencv && git checkout 3.4 && mkdir build
RUN cd /home/opencv/build && cmake -D CMAKE_BUILD_TYPE=RELEASE \
	    -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
            -D INSTALL_C_EXAMPLES=ON \
            -D INSTALL_PYTHON_EXAMPLES=ON \
            -D WITH_TBB=ON \
	    -D WITH_EGEIN=ON \
            -D WITH_V4L=ON \
        -D WITH_QT=ON \
        -D WITH_OPENGL=OFF \
        -D BUILD_EXAMPLES=OFF ..
RUN cd /home/opencv/build && make -j12 && make install

# --- OPENPOSE ----
RUN apt purge -y cmake-qt-gui cmake
RUN apt-get install -y libboost-all-dev wget
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.1/cmake-3.14.1.tar.gz
RUN tar xvzf cmake-3.14.1.tar.gz
RUN cd cmake-3.14.1 && bash configure && bash bootstrap
RUN cd cmake-3.14.1 && make -j12 && make install -j8

RUN apt-get install -y liblmdb-dev libleveldb-dev libsnappy-dev
RUN cd /home && git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git
RUN cd /home/openpose && mkdir build
RUN cd /home/openpose/build && cmake -DBUILD_PYTHON=ON ..
RUN cd /home/openpose/build && make -j12
RUN cd /home/openpose/build && make install -j12

RUN apt-get update && apt-get install -y mesa-utils and libgl1-mesa-glx x11-apps eog
RUN ln -s /usr/lib/x86_64-linux-gnu/libcudnn.so.7 /usr/local/cuda/lib64/libcudnn.so.7
RUN ln -s /usr/lib/x86_64-linux-gnu/libcudnn.so /usr/local/cuda/lib64/libcudnn.so

# version 0.7
RUN apt-get install -y vim
COPY scripts/exec_img.sh /exec_img.sh
COPY scripts/exec_vis.sh /exec_vis.sh
COPY scripts/exec_hm.sh /exec_hm.sh

# make sure the right GPU is used (in case of multi-GPU setups)
ENV CUDA_VISIBLE_DEVICES=0
