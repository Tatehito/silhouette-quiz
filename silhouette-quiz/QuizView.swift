import SwiftUI
import RealmSwift

struct QuizView: View {
    @Environment(\.dismiss) var dismiss
    
    var quizList: [Quiz]
    @State private var quizIndex: Int = 0
    @State private var quizTitle: String?
    @State private var displayImage: UIImage?
    @State private var isQuestionMode: Bool = true
    
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
                    .padding(.top, 20)
                    .padding(.bottom, 100)
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
                .padding(.bottom, 20)
            } else {
                Text(quizTitle!+"！")
                    .font(.system(size: 30, weight: .black))
                    .padding(.top, 20)
                    .padding(.bottom, 100)
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
                .padding(.bottom, 20)
            }
            Button("クイズをおわる") {
                dismiss()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.displayImage = quizList[quizIndex].questionImage
            self.quizTitle = quizList[quizIndex].title
        }
    }
    
    func handleClickShowAnswerImage() {
        self.displayImage = quizList[quizIndex].answerImage
        self.quizTitle = quizList[quizIndex].title
        self.isQuestionMode.toggle()
    }
    
    func handleClickNextQuestion() {
        if quizList.endIndex == (quizIndex + 1) {
            // 最後までいったら最初に戻る
            self.quizIndex = 0
        } else {
            self.quizIndex = quizIndex + 1
        }
        self.displayImage = quizList[quizIndex].questionImage
        self.quizTitle = quizList[quizIndex].title
        self.isQuestionMode.toggle()
    }
}
