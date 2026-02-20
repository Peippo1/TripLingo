import SwiftUI
import SwiftData

struct PhraseDetailView: View {
    @Environment(\.modelContext) private var modelContext

    let phrase: Phrase
    let destinationName: String
    let situationTitle: String

    @State private var isSaved = false

    var body: some View {
        List {
            Section("Target") {
                Text(phrase.targetText)
                    .font(.title3)
            }

            Section("Meaning") {
                Text(phrase.englishMeaning)
            }

            if let notes = phrase.notes, !notes.isEmpty {
                Section("Notes") {
                    Text(notes)
                }
            }

            Section {
                Button(isSaved ? "Saved" : "Save to Phrasebook") {
                    savePhrase()
                }
                .disabled(isSaved)
            }
        }
        .navigationTitle("Phrase")
        .onAppear {
            refreshSavedState()
        }
    }

    private func refreshSavedState() {
        let targetText = phrase.targetText
        let destination = destinationName
        let situation = situationTitle
        let descriptor = FetchDescriptor<SavedPhrase>(
            predicate: #Predicate { saved in
                saved.targetText == targetText &&
                saved.destinationName == destination &&
                saved.situationTitle == situation
            }
        )

        do {
            isSaved = try modelContext.fetch(descriptor).isEmpty == false
        } catch {
            isSaved = false
        }
    }

    private func savePhrase() {
        let targetText = phrase.targetText
        let destination = destinationName
        let situation = situationTitle
        let descriptor = FetchDescriptor<SavedPhrase>(
            predicate: #Predicate { saved in
                saved.targetText == targetText &&
                saved.destinationName == destination &&
                saved.situationTitle == situation
            }
        )

        do {
            if try modelContext.fetch(descriptor).isEmpty {
                let saved = SavedPhrase(
                    targetText: phrase.targetText,
                    englishMeaning: phrase.englishMeaning,
                    destinationName: destinationName,
                    situationTitle: situationTitle
                )
                modelContext.insert(saved)
                try modelContext.save()
            }
            isSaved = true
        } catch {
            assertionFailure("Failed to save phrase: \(error.localizedDescription)")
        }
    }
}
