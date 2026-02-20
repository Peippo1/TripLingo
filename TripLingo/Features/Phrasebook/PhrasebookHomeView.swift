import SwiftUI
import SwiftData

struct PhrasebookHomeView: View {
    @Query(sort: [SortDescriptor(\SavedPhrase.createdAt, order: .reverse)])
    private var savedPhrases: [SavedPhrase]

    var body: some View {
        Group {
            if savedPhrases.isEmpty {
                ContentUnavailableView(
                    "No Saved Phrases",
                    systemImage: "text.book.closed",
                    description: Text("Save a phrase from Lessons to see it here.")
                )
            } else {
                List(savedPhrases) { savedPhrase in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(savedPhrase.targetText)
                            .font(.headline)
                        Text(savedPhrase.englishMeaning)
                            .foregroundStyle(.secondary)
                        Text("\(savedPhrase.destinationName) • \(savedPhrase.situationTitle)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Phrasebook")
    }
}
