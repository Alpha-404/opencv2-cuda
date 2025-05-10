FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

# System setup
RUN apt-get update && apt-get install -y \
    build-essential cmake git wget unzip \
    python3-dev python3-pip python3-numpy \
    libgtk2.0-dev pkg-config libavcodec-dev \
    libavformat-dev libswscale-dev

# Install Python dependencies
RUN pip3 install numpy

# Clone OpenCV and OpenCV contrib
WORKDIR /opt
RUN git clone --depth 1 https://github.com/opencv/opencv.git
RUN git clone --depth 1 https://github.com/opencv/opencv_contrib.git

# Build OpenCV with CUDA
WORKDIR /opt/opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=Release \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
          -D WITH_CUDA=ON \
          -D ENABLE_FAST_MATH=1 \
          -D CUDA_FAST_MATH=1 \
          -D WITH_CUBLAS=1 \
          -D BUILD_opencv_python3=ON \
          -D BUILD_opencv_python2=OFF \
          -D BUILD_TESTS=OFF \
          -D BUILD_PERF_TESTS=OFF \
          -D BUILD_EXAMPLES=OFF \
          -D PYTHON3_EXECUTABLE=/usr/bin/python3 \
          -D PYTHON3_INCLUDE_DIR=/usr/include/python3.10 \
          -D PYTHON3_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.10.so \
          -D PYTHON3_PACKAGES_PATH=/usr/local/lib/python3.10/dist-packages \
          ..

RUN make -j$(nproc)
RUN make install

