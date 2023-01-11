import numpy as np
import cv2
import matplotlib.pyplot as plt

import torch
import torchvision
from torchvision import transforms

images = ['abe.jpeg', 'kuromi.jpeg', 'luffy.jpeg', 'luffy2.png', 'two_men.png']

for image in images:
    # 画像の読み込み
    image_path = './images/' + image
    img = cv2.imread(image_path)

    # BGR->RGBへ変換
    img = img[..., ::-1]
    h, w, _ = img.shape

    # DeepLabv3の入力サイズに合わせてリサイズ
    # TODO: 縦横比が変わってしまう
    img = cv2.resize(img, (320, 320))

    # デバイス
    # TODO: Linux?
    # device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    # M1Macの場合
    device = torch.device("mps")

    # 学習済みモデルの読み込み
    model = torchvision.models.segmentation.deeplabv3_resnet101(
        weights=torchvision.models.segmentation.DeepLabV3_ResNet101_Weights.DEFAULT)
    model = model.to(device)
    model.eval()

    # 前処理：tensor型へ変換 + 正規化
    preprocess = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                             std=[0.229, 0.224, 0.225]),
    ])
    input_tensor = preprocess(img)

    # バッチ化(ここではバッチサイズ=1)
    input_batch = input_tensor.unsqueeze(0).to(device)

    with torch.no_grad():
        output = model(input_batch)['out'][0]

    output = output.argmax(0)

    img = cv2.resize(img, (w, h))

    mask = output.byte().cpu().numpy()
    mask = cv2.resize(mask, (w, h))
    mask = cv2.bitwise_not(mask)

    # 画像描画
    plt.gray()
    plt.figure(figsize=(7, 7))
    plt.subplot(1, 2, 1)
    plt.imshow(img)
    plt.subplot(1, 2, 2)
    plt.imshow(mask)

# 表示
plt.show()
