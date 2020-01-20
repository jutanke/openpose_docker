cd /home/openpose && ./build/examples/openpose/openpose.bin\
    --display 0\
    --render_pose 0\
    --image_dir=/home/user/data\
    --write_json=/home/user/output \
    --heatmaps_add_PAFs\
    --heatmaps_add_parts\
    --heatmaps_add_bkg\
    --write_heatmaps=/home/user/output/heatmaps\
    --scale_number 4 --scale_gap=0.25
