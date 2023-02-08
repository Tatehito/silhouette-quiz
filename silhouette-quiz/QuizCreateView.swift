import SwiftUI
import PhotosUI

struct QuizCreateView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingQuestionImagePicker = false
    @State private var showingAnswerImagePicker = false
    
    @State private var answerUIImage: UIImage?
    @State private var questionUIImage: UIImage?

    @State private var quiz: QuizModel = QuizModel()

    var body: some View {
        VStack {
            Text("クイズのなまえ")
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("クイズのなまえをいれてください。", text: $quiz.title)
                .keyboardType(.default)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer()

            HStack {
                Text("こたえ")
                Button("しゃしんをえらぶ") {
                    handleClickSelectAnswerImageButton()
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }.frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                if let uiImage = answerUIImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
            }.frame(height: 200)

            HStack {
                Text("もんだい")
                Button("しゃしんをえらぶ") {
                    handleClickSelectQuestionImageButton()
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }.frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                if let uiImage = questionUIImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
            }.frame(height: 200)
            
            Spacer()

            Button(action: {
                handleClickSubmitButton()
            }){
                Text("ほぞんする")
                    .bold()
                    .padding()
                    .frame(width: 200, height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            // 上寄せにする
            Spacer()
            
        }.sheet(isPresented: $showingQuestionImagePicker) {
            SwiftUIPicker(image: $questionUIImage)

        }.sheet(isPresented: $showingAnswerImagePicker) {
            SwiftUIPicker(image: $answerUIImage)

        }.onChange(of: answerUIImage) { newImage in
            if answerUIImage == nil {
                return
            }
            questionUIImage = answerUIImage?.silhouetteImageGenerate()
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
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
}
