import SwiftUI
import RealmSwift

struct QuizListView: View {
    @State private var showingQuizCreateView = false
    @State private var isRandomMode = false
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: QuizCreateView().onDisappear(perform: {
                            self.quizList = loadQuiz()
                        })) {
                            Text("＋クイズをつくる")
                        }
                    }
                }
                // 背景色変更 16.0 >= iOS
                .scrollContentBackground(.hidden)
                .background(Color.white)
                .navigationBarTitle("", displayMode: .inline)
                .padding(.bottom, 130)
                
                VStack {
                    if (quizList.endIndex > 0) {
                        VStack {
                            NavigationLink(destination: QuizView(isRandomMode: isRandomMode, quizList: quizList)) {
                                Text("クイズをはじめる")
                                    .bold()
                                    .padding()
                                    .frame(width: 180, height: 50)
                                    .foregroundColor(Color.white)
                                    .background(Color.blue)
                                    .cornerRadius(25)
                            }
                            .padding(.bottom, 5)
                            Toggle("ランダム", isOn: $isRandomMode)
                                .frame(width: 125)
                        }
                    }
                }.padding(.horizontal, 30).padding(.bottom, 10)
                    
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
