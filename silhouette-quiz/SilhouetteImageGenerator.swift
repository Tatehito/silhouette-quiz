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
            // UIImageに変換
            let uiImage = UIImage(cgImage: convertCGImageFromPixelBuffer(from: result.pixelBuffer)!)
            // 色反転
            let ciImage:CIImage = CIImage(image: uiImage)!
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
    
    private func convertCGImageFromPixelBuffer(from pixelBuffer: CVPixelBuffer) -> CGImage? {
       let ciContext = CIContext()
       let ciImage = CIImage(cvImageBuffer: pixelBuffer)
       return ciContext.createCGImage(ciImage, from: ciImage.extent)
    }
}
