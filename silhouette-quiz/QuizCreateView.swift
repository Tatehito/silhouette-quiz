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

                saveQuiz(quiz: [Quiz(title: title)])
                dismiss()
            }
        }
    }
    
    func saveQuiz(quiz: [Quiz]) {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(quiz) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "quiz")
    }
}
