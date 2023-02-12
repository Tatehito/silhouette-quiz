import SwiftUI
import RealmSwift

struct QuizView: View {
    @Environment(\.dismiss) var dismiss
    
    let isRandomMode: Bool
    @State var quizList: [Quiz]
    @State private var quizIndex: Int = 0
    @State private var quizTitle: String?
    @State private var displayImage: UIImage?
    @State private var isQuestionMode: Bool = true
    @State private var isFinished: Bool = false
    
    var body: some View {
        VStack {
            if let uiImage = displayImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
            
            
            if (isQuestionMode) {
                Text("だーれだ？")
                    .font(.system(size: 30, weight: .black))
                    .frame(height: 80)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
            } else {
                Text(quizTitle!+"！")
                    .font(.system(size: 30, weight: .black))
                    .frame(height: 80)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
            }

            VStack {
                if (isQuestionMode) {
                    Button(action: {
                        handleClickShowAnswerImage()
                    }){
                        Text("こたえをみる")
                            .bold()
                            .padding()
                            .frame(width: 200, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                } else {
                    if (!isFinished) {
                        Button(action: {
                            handleClickNextQuestion()
                        }){
                            Text("つぎのもんだい")
                                .bold()
                                .padding()
                                .frame(width: 200, height: 50)
                                .foregroundColor(Color.white)
                                .background(Color.blue)
                                .cornerRadius(25)
                        }
                    }
                }
            }.frame(height: 100)

            Button("クイズをおわる") {
                dismiss()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if (isRandomMode) {
                quizList = quizList.shuffled()
            }
            displayImage = quizList[quizIndex].questionImage
            quizTitle = quizList[quizIndex].title
        }
        .padding(.horizontal, 20)
    }
    
    func handleClickShowAnswerImage() {
        if quizList.endIndex == (quizIndex + 1) {
            isFinished = true
        }
        displayImage = quizList[quizIndex].answerImage
        quizTitle = quizList[quizIndex].title
        isQuestionMode.toggle()
    }
    
    func handleClickNextQuestion() {
        quizIndex = quizIndex + 1
        displayImage = quizList[quizIndex].questionImage
        quizTitle = quizList[quizIndex].title
        isQuestionMode.toggle()
    }
}
