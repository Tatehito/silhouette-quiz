import UIKit
import SwiftUI
import CoreML
import Vision

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    // 使用しないが書かないとビルドエラーになる
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let selectedImage = info[.originalImage] as! UIImage
            guard let inputCgImage = selectedImage.cgImage else {
                fatalError("Photo doesn't have underlying CGImage.")
            }

            // Model読み込み
            guard let model = try? VNCoreMLModel(for: u2net(configuration: MLModelConfiguration()).model) else { fatalError("model initialization failed") }
            // Request作成
            let coreMLRequest = VNCoreMLRequest(model: model)
            // Handler作成
            let handler = VNImageRequestHandler(cgImage: inputCgImage, options: [:])
            do {
                // 実行
                try handler.perform([coreMLRequest])
                // 結果の取り出し
                let result = coreMLRequest.results?.first as! VNPixelBufferObservation
                let outputuiImage = UIImage(cgImage: createCGImage(from: result.pixelBuffer)!)
                parent.selectedImage = outputuiImage
            } catch let error {
                fatalError("inference error \(error)")
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func createCGImage(from pixelBuffer: CVPixelBuffer) -> CGImage? {
           let ciContext = CIContext()
           let ciImage = CIImage(cvImageBuffer: pixelBuffer)
           return ciContext.createCGImage(ciImage, from: ciImage.extent)
        }
    }
}
