import SwiftUI
import PhotosUI

struct QuizCreateView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingQuestionImagePicker = false
    @State private var showingAnswerImagePicker = false
    @State private var showingAlert = false

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
            
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("保存できませんでした"))
            
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
        if quiz.title == "" || questionUIImage == nil || answerUIImage == nil {
            return
        }
        
        // 画像をFileManagerに保存
        quiz.questionImageURL = saveImageDirectory(image: questionUIImage!)
        quiz.answerImageURL = saveImageDirectory(image: answerUIImage!)
        if (quiz.questionImageURL != nil && quiz.answerImageURL != nil) {
            // realmにクイズを保存
            quiz.create()
            dismiss()
        } else {
            showingAlert = true
        }
    }

    private func handleClickCancelButton() {
        dismiss()
    }

    func saveImageDirectory (image: UIImage, filename: String = UUID().uuidString) -> String? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        let fileURL = documentsURL.appendingPathComponent(filename)
        
        let pngImageData = image.pngData()
        do {
            try pngImageData!.write(to: URL(fileURLWithPath: fileURL!.path), options: .atomic)
        } catch {
            print(error)
            return nil
        }
        return fileURL?.absoluteString
    }
}
