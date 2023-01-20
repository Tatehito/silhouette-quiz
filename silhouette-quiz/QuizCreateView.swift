import SwiftUI

struct QuizCreateView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""

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
        }
    }
}
