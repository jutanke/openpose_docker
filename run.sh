docker run\
    --runtime=nvidia\
    --name='openpose_instance'\
    -v "$1":/home/data\
    --rm\
    -it openpose /bin/bash