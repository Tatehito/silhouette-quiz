import SwiftUI
import CoreML
import Vision

extension UIImage {
    func silhouetteImageGenerate() -> UIImage? {
        // CGImageに変換
        guard let inputCgImage = cgImage else { fatalError("CGImageの変換に失敗") }
        // Model読み込み
        guard let model = try? VNCoreMLModel(for: u2net(configuration: MLModelConfiguration()).model) else { fatalError("Model読み込みに失敗") }
        // Request作成
        let coreMLRequest = VNCoreMLRequest(model: model)
        // Handler作成
        let handler = VNImageRequestHandler(cgImage: inputCgImage, options: [:])
        do {
            // 実行
            try handler.perform([coreMLRequest])
            // 結果の取り出し
            let result = coreMLRequest.results?.first as! VNPixelBufferObservation
            // CIImageに変換
            let ciImage = CIImage(cvImageBuffer: result.pixelBuffer)
            // 色反転
            let ciFilter:CIFilter = CIFilter(name: "CIColorInvert")!
            ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
            let ciContext:CIContext = CIContext(options: nil)
            let cgimg:CGImage = ciContext.createCGImage(ciFilter.outputImage!, from:ciFilter.outputImage!.extent)!
            let outputUIImage:UIImage? = UIImage(cgImage: cgimg, scale: 1.0, orientation:UIImage.Orientation.up)
            
            return outputUIImage
        } catch let error {
            fatalError("シルエット画像の生成に失敗 \(error)")
        }
    }

    func trimmingSquare() -> UIImage {
        let imageW = self.size.width
        let imageH = self.size.height
        let targetSize = min( imageW, imageH)
        let posX = (imageW - targetSize) / 2
        let posY = (imageH - targetSize) / 2
        let trimArea = CGRectMake(posX, posY, targetSize, targetSize)
        
        let imgRef = self.cgImage?.cropping(to: trimArea)
        let trimImage = UIImage(cgImage: imgRef!, scale: self.scale, orientation: self.imageOrientation)
        return trimImage
    }
}
