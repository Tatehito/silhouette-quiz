import SwiftUI
import RealmSwift

struct QuizView: View {
    @Environment(\.dismiss) var dismiss
    
    var quizList: [Quiz]
    @State private var quizIndex: Int = 0
    @State private var displayImage: UIImage?
    @State private var isQuestionMode: Bool = true
    
    var body: some View {
        VStack {
            if let uiImage = displayImage {
                Image(uiImage: uiImage).resizable().scaledToFit()
            }
            if (isQuestionMode) {
                Button("こたえをみる") {
                    handleClickShowAnswerImage()
                }
            } else {
                Button("つぎのもんだい") {
                    handleClickNextQuestion()
                }
            }
            Button("クイズをおわる") {
                dismiss()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.displayImage = quizList[quizIndex].questionImage
        }
    }
    
    func handleClickShowAnswerImage() {
        self.displayImage = quizList[quizIndex].answerImage
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
        self.isQuestionMode.toggle()
    }
}
