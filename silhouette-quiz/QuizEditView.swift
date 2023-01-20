import SwiftUI
import RealmSwift

struct QuizEditView: View {
    @Environment(\.dismiss) var dismiss
    @State var quiz: Quiz?
    @State private var title = ""
    
    var body: some View {
        VStack {
            Text("ここはクイズ編集画面です。")
            TextField("クイズのなまえをいれてください。", text: $title).keyboardType(.default)
            Button("変更") {
                if title == "" { return }
                
                _ = quiz!.update(title: title)
                dismiss()

            }
        }
    }
}
