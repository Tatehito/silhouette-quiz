import SwiftUI

struct QuizEditView: View {
    @State var row: Int
    
    var body: some View {
        VStack {
            Text("ここは\(row)行目のクイズ編集画面です。")
        }
    }
}
