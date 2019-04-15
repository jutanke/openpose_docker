xhost +
nvidia-docker run\
    --privileged\
    --name='openpose_instance'\
    -v "$1":/home/data\
    -v "$2":/home/output\
    -e DISPLAY=$DISPLAY\
    -v /tmp/.X11-unix:/tmp/.X11-unix\
    --rm\
    -it jutanke/openpose /bin/bash