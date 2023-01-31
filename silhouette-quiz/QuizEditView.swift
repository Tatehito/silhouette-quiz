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
                    guard let imageData = convertToDataFromUIImage(image: uiImage) else { return }
                    createFile(
                        directoryName: quiz.directoryName,
                        fileName: "question.jpg",
                        contents: imageData
                    )
                }
                
                if let uiImage = answerUIImage {
                    guard let imageData = convertToDataFromUIImage(image: uiImage) else { return }
                    createFile(
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
    
    //TODO: 共通化する
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
    
    //TODO: 共通化する
    func convertToDataFromUIImage(image: UIImage) -> Data? {
        return image.pngData()
    }
}
