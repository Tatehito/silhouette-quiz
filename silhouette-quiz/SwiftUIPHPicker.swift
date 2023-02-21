import SwiftUI
import PhotosUI

struct SwiftUIPicker: UIViewControllerRepresentable{
    //SwiftUIと繋がるBindingオブジェクト
    @Binding var image: UIImage?
    @Binding var loading: Bool
    
    //Coordinatorでdelegateメソッドを処理してUIKit側の処理をさせる
    class Coordinator: NSObject, PHPickerViewControllerDelegate{
        var parent: SwiftUIPicker
        
        init(parent: SwiftUIPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else {
                return
            }
            self.parent.loading = true
            if provider.canLoadObject(ofClass: UIImage.self){
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    let uiImage = image as? UIImage
                    self.parent.image = uiImage?.trimmingSquare()
                    self.parent.loading = false
                }
            }
        }
    }

    //ViewControllerの作成：今回はPickerを返す
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        //delegateにはselfではなくcoordinatorを渡す
        picker.delegate = context.coordinator
        return picker
    }

    //UIViewControllerRepresentable自体のメソッド
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    //UIViewControllerRepresentable自体のメソッド
    func makeCoordinator() -> Coordinator {
        //ImagePickerをparentとしてセット
        Coordinator(parent: self)
    }
    
}
