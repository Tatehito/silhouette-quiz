import SwiftUI
import RealmSwift

struct QuizListView: View {
    @State private var showingQuizCreateView = false
    @State private var quizList: [Quiz] = []

    let realm = try! Realm()

    var body: some View {
        NavigationView {
            List {
                ForEach(quizList) { quiz in
                    NavigationLink(destination: QuizEditView(quiz: quiz).onDisappear(perform: {
                        self.quizList = loadQuiz()
                    })) {
                        Text("\(quiz.title)")
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
                    .sheet(isPresented : $showingQuizCreateView, onDismiss : {
                        self.quizList = loadQuiz()
                    }) {
                       QuizCreateView()
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("クイズをはじめる") {
                        
                    }
                }
            }
        }.onAppear {
            self.quizList = loadQuiz()
        }
    }
    
    func loadQuiz() -> [Quiz] {
        let quizModels = realm.objects(QuizModel.self)
        return quizModels.map {
            Quiz(quizModel: $0)
        }
    }
}
