import SwiftUI
import RealmSwift

struct QuizListView: View {
    @State private var showingQuizCreateView = false
    @State private var quizList: [Quiz] = []

    let realm = try! Realm()

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                List {
                    ForEach(quizList) { quiz in
                        ZStack {
                            NavigationLink(destination: QuizEditView(quiz: quiz).onDisappear(perform: {
                                self.quizList = loadQuiz()
                            })) {
                                EmptyView()
                            }
                            .opacity(0)
                            HStack {
                                Text("\(quiz.title)")
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            handleClickDeleteButton(quiz: quiz)
                                        } label: {
                                            Image(systemName: "trash.fill")
                                        }
                                    }
                                Spacer()
                            }
                        }
                    }
                }
                // 背景色変更 16.0 >= iOS
                .scrollContentBackground(.hidden)
                .background(Color.white)
                .navigationBarTitleDisplayMode(.inline)
                .padding(.bottom, 100)
                
                VStack {
                    NavigationLink(destination: QuizCreateView().onDisappear(perform: {
                        self.quizList = loadQuiz()
                    })) {
                        Text("＋")
                            .bold()
                            .padding()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(30)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }.padding(.bottom, 30)
                    
                    if (quizList.endIndex > 0) {
                        NavigationLink(destination: QuizView(quizList: quizList)) {
                            Text("クイズをはじめる")
                                .bold()
                                .padding()
                                .frame(width: 200, height: 50)
                                .foregroundColor(Color.white)
                                .background(Color.blue)
                                .cornerRadius(25)
                        }
                    }
                }.padding(.horizontal, 30).padding(.bottom, 30)
                    
            }.onAppear {
                self.quizList = loadQuiz()
            }
        }
    }
    
    func loadQuiz() -> [Quiz] {
        // 登録順の降順で表示する
        let quizModels = realm.objects(QuizModel.self)
        return quizModels.map {
            Quiz(quizModel: $0)
        }.reversed()
    }
    
    func handleClickDeleteButton(quiz: Quiz) {
        let quizObject = realm.objects(QuizModel.self).filter("directoryName == '\(quiz.directoryName)'")
        do {
            try realm.write {
                realm.delete(quizObject)
                FileManagerOperator.remove(quiz.directoryName)
                // リフレッシュ
                self.quizList = loadQuiz()
            }
        } catch {
          print("Error \(error)")
        }
    }
}
