import SwiftUI
import RealmSwift

struct QuizListView: View {
    @State private var showingQuizCreateView = false
    @State private var quizList: [Quiz]
    
    init() {
        let realm = try! Realm()
        let quizModels = realm.objects(QuizModel.self)
        self.quizList = quizModels.map {
            Quiz(quizModel: $0)
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(quizList) { quiz in
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
