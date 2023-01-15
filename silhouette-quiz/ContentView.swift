import SwiftUI

struct ContentView: View {
    @State private var image: UIImage?
    @State var showingImagePicker = false
        
    var body: some View {
        VStack {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 200, height: 200)
                    // 色反転
                    .colorInvert()
            } else {
                Text("シルエット画像をつくるぞ！")
            }
            Spacer().frame(height: 32)
            Button(action: {
                showingImagePicker = true
            }) {
                Text("フォトライブラリから選択")
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        }
    }
}
