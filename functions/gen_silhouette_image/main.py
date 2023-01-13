from flask import escape
import functions_framework
from rembg import remove
import numpy as np
import cv2


@functions_framework.http
def gen_silhouette_image(request):
    image_binary = request.data

    # オリジナル読み込み
    _bytes = np.frombuffer(image_binary, np.uint8)
    input = cv2.imdecode(_bytes, flags=cv2.IMREAD_COLOR)

    # 背景削除
    remove_bg = remove(input)

    # アルファチャンネルを取得
    output = remove_bg[:, :, 3]

    # 白黒反転
    output = cv2.bitwise_not(output)

    # f = open(output, "rb")
    # res = f.read()

    return 'input'
