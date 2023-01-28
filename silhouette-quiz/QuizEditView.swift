import SwiftUI
import RealmSwift

struct QuizEditView: View {
    @Environment(\.dismiss) var dismiss

    @State var quiz: Quiz
    
    let realm = try! Realm()
    
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
                
                let model = realm.objects(QuizModel.self).filter("directoryName == %@", quiz.directoryName)[0]
                _ = model.update(title: quiz.title)
                dismiss()
            }
        }
    }
}
