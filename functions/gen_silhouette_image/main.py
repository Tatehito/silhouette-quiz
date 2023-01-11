import functions_framework
import rembg
import cv2
import numpy as np


@functions_framework.http
def gen_silhouette_image(request):
    request_args = request.args

    # オリジナル読み込み
    _bytes = np.frombuffer(request_args['image'], np.uint8)
    input = cv2.imdecode(_bytes, flags=cv2.IMREAD_COLOR)

    # 背景削除
    remove_bg = rembg.remove(input)

    # アルファチャンネルを取得
    output = remove_bg[:, :, 3]

    # 白黒反転
    output = cv2.bitwise_not(output)

    f = open(output, "rb")
    res = f.read()

    return res
