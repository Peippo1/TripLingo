import SwiftUI

struct LessonsHomeView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Situation-based micro-lessons for your destination will appear here.")
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding()
            .navigationTitle("Lessons")
        }
    }
}

#Preview {
    LessonsHomeView()
}
