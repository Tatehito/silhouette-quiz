import SwiftUI

struct QuizListView: View {
    var body: some View {
        NavigationView {
            List(1..<20) { index in
                NavigationLink(destination: QuizCreateView(row: index)) {
                    Text("\(index)行目")
                }
            }
            .navigationTitle("クイズ一覧")
        }
    }
}
