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
        createDirectory(directoryName: directoryName)
        createFile(
            directoryName: directoryName,
            fileName: "question.jpg",
            contents: convertToDataFromUIImage(image: questionUIImage!)!
        )
        createFile(
            directoryName: directoryName,
            fileName: "answer.jpg",
            contents: convertToDataFromUIImage(image: answerUIImage!)!
        )
        
        // realmにクイズを保存
        quiz.directoryName = directoryName
        quiz.create()

        dismiss()
    }

    private func handleClickCancelButton() {
        dismiss()
    }
    
    func createDirectory(directoryName: String) {
        let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directory = documentDirectoryFileURL.appendingPathComponent(directoryName, isDirectory: true)

        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func createFile(directoryName: String, fileName: String, contents: Data) {
        var pathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        pathString = "file://" + pathString + "/" + "\(directoryName)/"
        guard let directoryPath = URL(string: pathString) else { return }
        let filePath = directoryPath.appendingPathComponent(fileName)
        
        do {
            try contents.write(to: filePath)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func convertToDataFromUIImage(image: UIImage) -> Data? {
        return image.pngData()
    }
}
