import SwiftUI
import PhotosUI

struct QuizCreateView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingImagePicker = false
    @State private var title = ""
    @State private var image: Image?
    @State private var inputImage: UIImage?

    var body: some View {
        VStack {
            Text("ここはクイズ登録画面です。")
            Button("キャンセル") {
                dismiss()
            }
            TextField("クイズのなまえをいれてください。", text: $title).keyboardType(.default)
            Button("登録") {
                if title == "" { return }

                _ = Quiz.create(title: title)
                dismiss()
            }
            Button(action: {
                showingImagePicker = true
            }) {
                Text("もんだいの写真を選択")
            }
            image?.resizable().scaledToFit()
        }.sheet(isPresented: $showingImagePicker) {
            SwiftUIPicker(image: $inputImage)
        }.onChange(of: inputImage) { newValue in
            loadImage()
        }
    }
    
    func loadImage(){
        guard let inputImage = inputImage else {return}
        image = Image(uiImage: inputImage)
    }
}
