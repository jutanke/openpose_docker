if test "$#" -ne 2; then
    echo "Expected two keywords: \$data_dir \$output_dir"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Input directory '$1' does not exist! (exit)"
    exit 1
fi

if [ ! -d "$2" ]; then
    echo "Output directory '$2' does not exist!"
    read -p "\tcreate it [y/n]? "  yn
    if [ "$yn" == "y" ]; then
        mkdir "$2"
    else
        echo "(exit)"
        exit 1
    fi
fi

nvidia-docker run\
    --privileged\
    -v "$1":/home/user/data\
    -v "$2":/home/user/output\
    --rm\
    -it jutanke/openpose\
    /bin/bash exec_hm.sh
