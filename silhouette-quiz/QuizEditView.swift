import SwiftUI
import RealmSwift
import Combine

struct QuizEditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingAnswerImagePicker = false
    @State private var loading = false
    @FocusState var titleFocus: Bool
    
    @State private var questionUIImage: UIImage?
    @State private var answerUIImage: UIImage?

    @State var quiz: Quiz
    
    let realm = try! Realm()
    
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
                    TextField("クイズのなまえをいれてください。", text: $quiz.title)
                        .onReceive(Just(quiz.title), perform: { _ in
                            if Quiz.titleMaxLength < quiz.title.count {
                                quiz.title = String(quiz.title.prefix(Quiz.titleMaxLength))
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
                    
                    if (loading) {
                        Text("シルエットをつくっています...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } else {
                        HStack(alignment: .top) {
                            Text("こたえ")
                                .frame(width: 70, alignment: .leading)
                            Spacer()
                            if let uiImage = answerUIImage {
                                Image(uiImage: uiImage).resizable().scaledToFit()
                            } else {
                                Image(uiImage: quiz.answerImage).resizable().scaledToFit()
                            }
                            Spacer()
                        }.onTapGesture {
                            self.titleFocus = false
                        }.frame(height: 170)

                        HStack(alignment: .top) {
                            Text("もんだい")
                                .frame(width: 70, alignment: .leading)
                            Spacer()
                            if let uiImage = questionUIImage {
                                Image(uiImage: uiImage).resizable().scaledToFit()
                            } else {
                                Image(uiImage: quiz.questionImage).resizable().scaledToFit()
                            }
                            Spacer()
                        }.onTapGesture {
                            self.titleFocus = false
                        }.frame(height: 170)
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
        self.titleFocus = false
        showingAnswerImagePicker = true
    }
    
    private func handleClickSubmitButton() {
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
}
