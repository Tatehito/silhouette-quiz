import SwiftUI

struct QuizListView: View {
    @State private var showingQuizCreateView = false
    var quizList:[Quiz] = []
    
    init() {
        self.quizList = loadQuiz()!
    }

    var body: some View {
        NavigationView {
            List(0 ..< quizList.count) { item in
                let quiz = quizList[item]
                NavigationLink(destination: QuizEditView(title: quiz.title)) {
                    Text(quiz.title)
                }
            }
            .navigationTitle("クイズ一覧")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("クイズをつくる") {
                        self.showingQuizCreateView.toggle()
                    }
                    .sheet(isPresented: $showingQuizCreateView, onDismiss: {
                        // もどってきたときの処理
                    }) {
                        QuizCreateView()
                    }
                }
            }
        }
    }
    
    func loadQuiz() -> [Quiz]? {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "quiz"),
              let quiz = try? jsonDecoder.decode([Quiz].self, from: data) else {
            return nil
        }
        return quiz
    }
}
