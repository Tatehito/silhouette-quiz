import SwiftUI
import CoreML
import Vision

class SilhouetteImageGenerator {
    class func execute(targetImage: UIImage) -> UIImage? {
        // CGImageに変換
        guard let inputCgImage = targetImage.cgImage else { fatalError("CGImageの変換に失敗") }
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
            // UIImageに変換
            let outputuiImage = UIImage(cgImage: createCGImage(from: result.pixelBuffer)!)
            // TODO: 色反転
            return outputuiImage
        } catch let error {
            fatalError("シルエット画像の生成に失敗 \(error)")
        }
    }
    
    
    private class func createCGImage(from pixelBuffer: CVPixelBuffer) -> CGImage? {
       let ciContext = CIContext()
       let ciImage = CIImage(cvImageBuffer: pixelBuffer)
       return ciContext.createCGImage(ciImage, from: ciImage.extent)
    }
}
