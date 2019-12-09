import cv2
import numpy as np
import json
import sys
from os.path import isdir, isfile, join, splitext
from os import makedirs, listdir
import shutil
import matplotlib.pylab as plt
from tqdm import tqdm


COLORS = plt.rcParams['axes.prop_cycle'].by_key()['color']
N_COLORS = len(COLORS)

assert len(sys.argv) == 4, "expected params: {img-dir} {keypoint-dir} {output-dir}"

img_dir = sys.argv[1]
keypoints_dir = sys.argv[2]
output_dir = sys.argv[3]

if isdir(output_dir):
    shutil.rmtree(output_dir)
makedirs(output_dir)


for file in tqdm(listdir(img_dir)):
    basename = splitext(file)[0]
    keypoints_name = join(keypoints_dir, basename + '_keypoints.json')
    image_name = join(img_dir, file)


    dpi = 96
    img = cv2.cvtColor(cv2.imread(image_name), cv2.COLOR_BGR2RGB)
    h, w, _ = img.shape
    h_inches = h * (1/96)
    w_inches = w * (1/96)
    fig = plt.figure(figsize=(w_inches, h_inches))
    ax = fig.add_subplot(111)
    ax.imshow(img)

    pairs = [
        (0, 15), (0, 16), (0, 17), (0, 18), (16, 18), (17, 15),
        (0, 1), (17, 1), (18, 1), (1, 2), (1, 5),
        (2, 9), (5, 12), (9, 8), (8, 12), (2, 3), (3, 4),
        (5, 6), (6, 7), (9, 10), (10, 11), (11, 24), 
        (11, 22), (22, 23), (23, 24),
        (12, 13), (13, 14), (14, 21), (14, 20), (20, 19), (19, 21),
        (14, 19), (11, 23)
    ]


    with open(keypoints_name, 'r') as f:
        kp = json.load(f)
    
    for pid, person in enumerate(kp['people']):
        color = COLORS[pid % N_COLORS]
        pts2d = np.reshape(person['pose_keypoints_2d'], (-1, 3))
        pts2d_ = []
        CNTR = 0
        for x, y, v in pts2d:
            if v > 0.1:
                pts2d_.append((x, y))
            # ax.text(x, y, str(CNTR))
            CNTR += 1
        if len(pts2d_) > 0:
            pts2d_ = np.array(pts2d_)
            ax.scatter(pts2d_[:, 0], pts2d_[:, 1], color=color)
    
        for a, b in pairs:
            xa, ya, va = pts2d[a]
            xb, yb, vb = pts2d[b]
            if va > 0.1 and vb > 0.1:
                ax.plot([xa, xb], [ya, yb], color=color)


    out_name = join(output_dir, basename + '_kp.png')
    plt.axis('off')
    plt.tight_layout()
    plt.savefig(out_name)
    
    fig.clf()


# fname = join(self.loc, self.naming + '_keypoints.json') % (frame, )
#         assert isfile(fname), fname
#         with open(fname, 'r') as f:
#             kp = json.load(f)