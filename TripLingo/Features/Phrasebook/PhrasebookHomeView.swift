import SwiftUI

struct PhrasebookHomeView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Saved travel phrases and quick access favorites will appear here.")
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding()
            .navigationTitle("Phrasebook")
        }
    }
}

#Preview {
    PhrasebookHomeView()
}
