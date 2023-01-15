import SwiftUI

struct QuizCreateView: View {
    @State var row: Int
    
    var body: some View {
        VStack {
            Text("ここは\(row)行目のクイズ登録画面です。")
        }
    }
}
