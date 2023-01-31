import SwiftUI
import RealmSwift

struct QuizEditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingQuestionImagePicker = false
    @State private var showingAnswerImagePicker = false
    
    @State private var questionUIImage: UIImage?
    @State private var answerUIImage: UIImage?

    @State var quiz: Quiz
    
    let realm = try! Realm()
    
    var body: some View {
        VStack {
            Text("ここはクイズ編集画面です。")
            TextField("クイズのなまえをいれてください。", text: $quiz.title).keyboardType(.default)
            Text("もんだい")
            if let uiImage = questionUIImage {
                Image(uiImage: uiImage).resizable().scaledToFit()
            } else {
                Image(uiImage: quiz.questionImage).resizable().scaledToFit()
            }
            Button("もんだいの写真を選択") {
                handleClickSelectQuestionImageButton()
            }
            Text("こたえ")
            if let uiImage = answerUIImage {
                Image(uiImage: uiImage).resizable().scaledToFit()
            } else {
                Image(uiImage: quiz.answerImage).resizable().scaledToFit()
            }
            Button("こたえの写真を選択") {
                handleClickSelectAnswerImageButton()
            }
            Button("変更") {
                // 入力チェック
                if quiz.title == "" {
                    return
                }
                
                // TODO: トランザクションしたい
                
                if let uiImage = questionUIImage {
                    guard let imageData = FileManagerOperator.convertToDataFromUIImage(image: uiImage) else { return }
                    FileManagerOperator.createFile(
                        directoryName: quiz.directoryName,
                        fileName: "question.jpg",
                        contents: imageData
                    )
                }
                if let uiImage = answerUIImage {
                    guard let imageData = FileManagerOperator.convertToDataFromUIImage(image: uiImage) else { return }
                    FileManagerOperator.createFile(
                        directoryName: quiz.directoryName,
                        fileName: "answer.jpg",
                        contents: imageData
                    )
                }
                
                let model = realm.objects(QuizModel.self).filter("directoryName == %@", quiz.directoryName)[0]
                _ = model.update(title: quiz.title)
                dismiss()
            }
            
        }.sheet(isPresented: $showingQuestionImagePicker) {
            SwiftUIPicker(image: $questionUIImage)

        }.sheet(isPresented: $showingAnswerImagePicker) {
            SwiftUIPicker(image: $answerUIImage)
        }
    }
    
    private func handleClickSelectQuestionImageButton() {
        showingQuestionImagePicker = true
    }
    
    private func handleClickSelectAnswerImageButton() {
        showingAnswerImagePicker = true
    }
}
