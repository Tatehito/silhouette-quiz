import SwiftUI

struct Quiz: Identifiable {
    var id = UUID()
    var title: String
    var questionImage: UIImage
    var answerImage: UIImage

    init(quizModel: QuizModel) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let questionImageURL = documentsURL.appendingPathComponent(quizModel.directoryName! + "/question.jpg")
        let answerImageURL = documentsURL.appendingPathComponent(quizModel.directoryName! + "/answer.jpg")
        
        self.title = quizModel.title
        self.questionImage = UIImage(contentsOfFile: questionImageURL.path)!
        self.answerImage = UIImage(contentsOfFile: answerImageURL.path)!
    }
}
