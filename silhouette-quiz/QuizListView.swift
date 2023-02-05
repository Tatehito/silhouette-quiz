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
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                handleClickDeleteButton(quiz: quiz)
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                        }
                    }
                }
            }
            .navigationTitle("クイズ一覧")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: QuizCreateView().onDisappear(perform: {
                        self.quizList = loadQuiz()
                    })) {
                        Text("クイズをつくる")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    if (quizList.endIndex > 0) {
                        NavigationLink(destination: QuizView(quizList: quizList)) {
                            Text("クイズをはじめる")
                        }
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
    
    func handleClickDeleteButton(quiz: Quiz) {
        let quizObject = realm.objects(QuizModel.self).filter("directoryName == '\(quiz.directoryName)'")
        do{
            try realm.write{
                realm.delete(quizObject)
                FileManagerOperator.remove(quiz.directoryName)
          }
        }catch {
          print("Error \(error)")
        }
    }
}
