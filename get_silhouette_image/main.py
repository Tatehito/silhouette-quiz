import urllib.parse
import urllib.request

import numpy as np
import cv2
import matplotlib.pyplot as plt


# read image data
f = open("images/lion.jpeg", "rb")
reqbody = f.read()
f.close()

# create request with urllib
url = "https://us-central1-silhouette-quiz.cloudfunctions.net/gen_silhouette_image"
req = urllib.request.Request(
    url,
    reqbody,
    method="POST",
    headers={"Content-Type": "application/octet-stream"},
)

# send the request and print response
with urllib.request.urlopen(req) as res:
    image_binary = res.read()
    _bytes = np.frombuffer(image_binary, np.uint8)
    image = cv2.imdecode(_bytes, flags=cv2.IMREAD_COLOR)

# 画像表示
# plt.gray()
# plt.figure(figsize=(7, 7))
# plt.subplot(1, 2, 1)
# plt.imshow(input[..., ::-1])  # RGBに変換して表示
# plt.subplot(1, 2, 2)
plt.imshow(image)
plt.show()
