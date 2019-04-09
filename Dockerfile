FROM nvidia/cuda:8.0-cudnn7-devel-ubuntu16.04

RUN apt-get update
RUN apt-get install -y build-essential \
    checkinstall \
    cmake \
    pkg-config \
    yasm \
    git \
    gfortran \
    libjpeg8-dev libjasper-dev libpng12-dev \
    libtiff5-dev \
    libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev \
    libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev \
    libxine2-dev libv4l-dev \
    libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev \
    qt5-default libgtk2.0-dev libtbb-dev \
    libatlas-base-dev \
    libfaac-dev libmp3lame-dev libtheora-dev \
    libvorbis-dev libxvidcore-dev \
    libopencore-amrnb-dev libopencore-amrwb-dev \
    x264 v4l-utils \
    libprotobuf-dev protobuf-compiler \
    libgoogle-glog-dev libgflags-dev \
    libgphoto2-dev libeigen3-dev libhdf5-dev doxygen

RUN apt-get install -y python-dev python-pip python3-dev python3-pip
RUN pip2 install -U pip numpy
RUN pip3 install -U pip numpy

RUN cd /home && git clone https://github.com/opencv/opencv.git
RUN cd /home/opencv && git checkout 3.4 && mkdir build
RUN cd /home/opencv/build && cmake -D CMAKE_BUILD_TYPE=RELEASE \
            -D INSTALL_C_EXAMPLES=ON \
            -D INSTALL_PYTHON_EXAMPLES=ON \
            -D WITH_TBB=ON \
            -D WITH_V4L=ON \
        -D WITH_QT=ON \
        -D WITH_OPENGL=ON \
        -D BUILD_EXAMPLES=ON ..
RUN cd /home/opencv/build && make -j12 && make install

