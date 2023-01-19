import SwiftUI

struct QuizListView: View {
    @State private var showingQuizCreateView = false
    @State var quizList:[Quiz] = []
    
    init() {
        self.quizList = loadQuiz()
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(quizList, id: \.id) { quiz in
                    NavigationLink(destination: QuizEditView(title: quiz.title)) {
                        Text(quiz.title)
                    }
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
                        self.quizList = loadQuiz()
                    }) {
                        QuizCreateView()
                    }
                }
            }
        }
    }
    
    func loadQuiz() -> [Quiz] {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "quiz"),
              let quiz = try? jsonDecoder.decode([Quiz].self, from: data) else {
            return []
        }
        return quiz
    }
}
