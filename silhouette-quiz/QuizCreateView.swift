import SwiftUI
import PhotosUI

struct QuizCreateView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingQuestionImagePicker = false
    @State private var showingAnswerImagePicker = false

    @State private var questionUIImage: UIImage?
    @State private var answerUIImage: UIImage?

    @State private var quiz: Quiz = Quiz()

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
                handleClickCancelButton()
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
        // 入力チェック
        if quiz.title == "" { return }
        
        // 画像をFileManagerに保存
        
        // realmにクイズを保存
        quiz.create()
        dismiss()
    }

    private func handleClickCancelButton() {
        dismiss()
    }
}
