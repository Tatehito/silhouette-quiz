import SwiftUI

struct QuizCreateView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("ここはクイズ登録画面です。")
            Button("キャンセル") {
                dismiss()
            }
        }
    }
}
