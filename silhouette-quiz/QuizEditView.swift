import SwiftUI
import RealmSwift

struct QuizEditView: View {
    @Environment(\.dismiss) var dismiss

    @State var quiz: Quiz
    
    var body: some View {
        VStack {
            Text("ここはクイズ編集画面です。")
            TextField("クイズのなまえをいれてください。", text: $quiz.title).keyboardType(.default)
            Text("もんだい")
            Image(uiImage: quiz.questionImage).resizable().scaledToFit()
            Text("こたえ")
            Image(uiImage: quiz.answerImage).resizable().scaledToFit()
            Button("変更") {
                if quiz.title == "" { return }
                
//                _ = quiz!.update(title: title, questionImageURL: "", answerImageURL: "")
                dismiss()

            }
        }
    }
}
