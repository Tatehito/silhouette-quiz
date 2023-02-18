import SwiftUI
import PhotosUI
import Combine

struct QuizCreateView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingAnswerImagePicker = false
    @State private var loading = false
    @FocusState var titleFocus: Bool
    
    @State private var quizTitle: String = ""
    @State private var answerUIImage: UIImage?
    @State private var questionUIImage: UIImage?

    var body: some View {
        GeometryReader { _ in
            ZStack {
                Color.white
                    .opacity(1.0)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.titleFocus = false
                    }
                
                VStack {
                    Text("クイズのなまえ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("クイズのなまえをいれてください。", text: $quizTitle)
                        .onReceive(Just(quizTitle), perform: { _ in
                            if Quiz.titleMaxLength < quizTitle.count {
                                quizTitle = String(quizTitle.prefix(Quiz.titleMaxLength))
                            }
                        })
                        .focused(self.$titleFocus)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 10)
                    
                    Button("しゃしんをえらぶ") {
                        handleClickSelectAnswerImageButton()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                    
                    if ((answerUIImage != nil) && (questionUIImage != nil)) {
                        HStack(alignment: .top) {
                            Text("こたえ")
                                .frame(width: 70, alignment: .leading)
                            Spacer()
                            Image(uiImage: answerUIImage!)
                                .resizable()
                                .scaledToFit()
                            Spacer()
                        }.onTapGesture {
                            self.titleFocus = false
                        }.frame(height: 170)
                        
                        HStack(alignment: .top) {
                            Text("もんだい")
                                .frame(width: 70, alignment: .leading)
                            Spacer()
                            Image(uiImage: questionUIImage!)
                                .resizable()
                                .scaledToFit()
                            Spacer()
                        }.onTapGesture {
                            self.titleFocus = false
                        }.frame(height: 170)
                        
                    } else {
                        if (loading) {
                            Text("シルエットをつくっています...")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        }
                    }

                    VStack {
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
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 10)

                    // 上寄せにする
                    Spacer()
                    
                }.sheet(isPresented: $showingAnswerImagePicker) {
                    SwiftUIPicker(image: $answerUIImage, loading: $loading)
                    
                }.onChange(of: answerUIImage) { newImage in
                    if answerUIImage == nil {
                        return
                    }
                    questionUIImage = answerUIImage?.silhouetteImageGenerate()
                }
                // navigationBarBackButtonのカスタマイズ
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.backward")
                                    .font(.system(size: 17, weight: .medium))
                                Text("もどる")
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
            }
        // キーボード表示時に全体が上に迫り上がるのを防止する
        }.ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private func handleClickSelectAnswerImageButton() {
        titleFocus = false
        showingAnswerImagePicker = true
    }
    
    private func handleClickSubmitButton() {
        // TODO: 入力チェック
        if quizTitle == "" || questionUIImage == nil || answerUIImage == nil {
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
        let quizModel = QuizModel()
        quizModel.title = quizTitle
        quizModel.directoryName = directoryName
        quizModel.create()

        dismiss()
    }
}
