if test "$#" -ne 1; then
    echo "Expected one keyword: \$data_dir"
    exit 1
fi

xhost +
nvidia-docker run\
    --privileged\
    -e DISPLAY=$DISPLAY\
    --name='openpose_instance_visualize'\
    -v /tmp/.X11-unix:/tmp/.X11-unix\
    -v "$1":/home/user/data\
    --rm\
    -it jutanke/openpose\
    /bin/bash exec_vis.sh