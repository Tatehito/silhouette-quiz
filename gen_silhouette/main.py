import rembg
import cv2
import matplotlib.pyplot as plt

images = ['abe.jpeg', 'kuromi.jpeg', 'luffy.jpeg',
          'luffy2.png', 'two_men.png', 'lion.jpeg']

for file_name in images:
    # オリジナル読み込み
    original_img_path = "images/" + file_name
    input = cv2.imread(original_img_path)

    # 背景削除
    remove_bg = rembg.remove(input)

    # アルファチャンネルを取得
    output = remove_bg[:, :, 3]

    # 白黒反転
    output = cv2.bitwise_not(output)

    # 保存
    # cv2.imwrite("combine/" + file_name, output)

    # 画像描画
    plt.gray()
    plt.figure(figsize=(7, 7))
    plt.subplot(1, 2, 1)
    plt.imshow(input[..., ::-1])  # RGBに変換して表示
    plt.subplot(1, 2, 2)
    plt.imshow(output)

# 表示
plt.show()
