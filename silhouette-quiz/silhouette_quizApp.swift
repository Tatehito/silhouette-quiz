import SwiftUI

@main
struct silhouette_quizApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            QuizListView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    // 起動時に1回だけ実行する処理
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let visit = UserDefaults.standard.bool(forKey: "visit")
        if visit {
            // 2回目以降はなにもしない
        } else {
            // 初回起動時
            createSampleQuiz(
                title: "月",
                questionUIImage: UIImage(named: "sampleImage1/question")!,
                answerUIImage: UIImage(named: "sampleImage1/answer")!
            )
            createSampleQuiz(
                title: "太陽",
                questionUIImage: UIImage(named: "sampleImage2/question")!,
                answerUIImage: UIImage(named: "sampleImage2/answer")!
            )
            createSampleQuiz(
                title: "草原",
                questionUIImage: UIImage(named: "sampleImage3/question")!,
                answerUIImage: UIImage(named: "sampleImage3/answer")!
            )
            UserDefaults.standard.set(true, forKey: "visit")
        }
        return true
    }
    
    func createSampleQuiz(title: String, questionUIImage: UIImage, answerUIImage: UIImage) {
        // TODO: createやeditと処理がほぼ同じなので汎用化したい
        let directoryName = UUID().uuidString
        FileManagerOperator.createDirectory(directoryName: directoryName)
        // documentディレクトリに画像を保存
        guard let questionUIImageData = FileManagerOperator.convertToDataFromUIImage(image: questionUIImage) else { return }
        FileManagerOperator.createFile(
            directoryName: directoryName,
            fileName: "question.jpg",
            contents: questionUIImageData
        )
        guard let answerUIImageData = FileManagerOperator.convertToDataFromUIImage(image: answerUIImage) else { return }
        FileManagerOperator.createFile(
            directoryName: directoryName,
            fileName: "answer.jpg",
            contents: answerUIImageData
        )
        
        // realmにクイズを保存
        var quiz = QuizModel()
        quiz.directoryName = directoryName
        quiz.title = title
        quiz.create()
    }
}
