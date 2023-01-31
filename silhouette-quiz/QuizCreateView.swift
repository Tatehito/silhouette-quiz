import SwiftUI
import PhotosUI

struct QuizCreateView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingQuestionImagePicker = false
    @State private var showingAnswerImagePicker = false

    @State private var questionUIImage: UIImage?
    @State private var answerUIImage: UIImage?

    @State private var quiz: QuizModel = QuizModel()

    var body: some View {
        VStack {
            Text("ここはクイズ登録画面です。")
            TextField("クイズのなまえをいれてください。", text: $quiz.title).keyboardType(.default)
            Button("もんだいの写真を選択") {
                handleClickSelectQuestionImageButton()
            }
            if let uiImage = questionUIImage {
                Image(uiImage: uiImage).resizable().scaledToFit()
            }
            Button("こたえの写真を選択") {
                handleClickSelectAnswerImageButton()
            }
            if let uiImage = answerUIImage {
                Image(uiImage: uiImage).resizable().scaledToFit()
            }
            Button("登録") {
                handleClickSubmitButton()
            }
            Button("キャンセル") {
                handleClickCancelButton()
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
    
    private func handleClickSubmitButton() {
        // TODO: 入力チェック
        if quiz.title == "" || questionUIImage == nil || answerUIImage == nil {
            return
        }

        // TODO: トランザクション

        // 画像をFileManagerに保存
        let directoryName = UUID().uuidString
        FileManagerOperator.createDirectory(directoryName: directoryName)
        
        if let uiImage = questionUIImage {
            guard let imageData = FileManagerOperator.convertToDataFromUIImage(image: uiImage) else { return }
            FileManagerOperator.createFile(
                directoryName: directoryName,
                fileName: "question.jpg",
                contents: imageData
            )
        }
        if let uiImage = answerUIImage {
            guard let imageData = FileManagerOperator.convertToDataFromUIImage(image: uiImage) else { return }
            FileManagerOperator.createFile(
                directoryName: directoryName,
                fileName: "answer.jpg",
                contents: imageData
            )
        }
        
        // realmにクイズを保存
        quiz.directoryName = directoryName
        quiz.create()

        dismiss()
    }

    private func handleClickCancelButton() {
        dismiss()
    }
}
