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
        // 入力チェック
        if quiz.title == "" || questionUIImage == nil || answerUIImage == nil {
            return
        }

        // TODO: トランザクション

        // 画像をFileManagerに保存
        let directoryName = UUID().uuidString
        createDirectory(atPath: directoryName)
        createFile(
            atPath: directoryName + "/question",
            contents: convertToDataFromUIImage(image: questionUIImage!)
        )
        createFile(
            atPath: directoryName + "/answer",
            contents: convertToDataFromUIImage(image: answerUIImage!)
        )
        
        // realmにクイズを保存
        quiz.directoryName = directoryName
        quiz.create()

        dismiss()
    }

    private func handleClickCancelButton() {
        dismiss()
    }
    
    private func convertPath(_ path: String) -> String {
        let rootDirectory = NSHomeDirectory() + "/Documents"

        if path.hasPrefix("/") {
            return rootDirectory + path
        }
        return rootDirectory + "/" + path
    }
    
    func createDirectory(atPath path: String) {
        if FileManager.default.fileExists(atPath: convertPath(path)) {
            return
        }
        do {
            try FileManager.default.createDirectory(atPath: convertPath(path), withIntermediateDirectories: false, attributes: nil)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func createFile(atPath path: String, contents: Data?) {
        if !FileManager.default.createFile(atPath: convertPath(path), contents: contents, attributes: nil) {
            print("Create file error")
        }
    }
    
    func convertToDataFromUIImage(image: UIImage) -> Data? {
        return image.pngData()
    }
}
