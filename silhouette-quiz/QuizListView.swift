import SwiftUI

struct QuizListView: View {
    @State private var showingQuizCreateView = false

    var body: some View {
        NavigationView {
            List(1..<11) { index in
                NavigationLink(destination: QuizEditView(row: index)) {
                    Text("\(index)つ目のクイズ")
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
