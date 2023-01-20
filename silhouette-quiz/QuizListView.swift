import SwiftUI
import RealmSwift

struct QuizListView: View {
    @State private var showingQuizCreateView = false
    @ObservedResults(Quiz.self) var quizzes

    var body: some View {
        NavigationView {
            List {
                ForEach(quizzes) { quiz in
                    Text("\(quiz.title)")
                }
            }
            .navigationTitle("クイズ一覧")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("クイズをつくる") {
                        self.showingQuizCreateView.toggle()
                    }
                    .sheet(isPresented: $showingQuizCreateView) {
                        QuizCreateView()
                    }
                }
            }
        }
    }
}
