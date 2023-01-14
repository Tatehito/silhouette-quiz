import SwiftUI

struct ContentView: View {
    @State private var image: UIImage?
    @State private var text: String?
    @State var showingImagePicker = false
        
    var body: some View {
        VStack {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                Text(text!)
            } else {
                Text("noimage")
            }
            Spacer().frame(height: 32)
            Button(action: {
                showingImagePicker = true
            }) {
                Text("フォトライブラリから選択")
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image, text: $text)
        }
    }
}
