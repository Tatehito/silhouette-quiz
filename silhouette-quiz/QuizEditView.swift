import SwiftUI

struct QuizEditView: View {
    @State var title: String
    
    var body: some View {
        VStack {
            Text("ここは\(title)のクイズ編集画面です。")
        }
    }
}
