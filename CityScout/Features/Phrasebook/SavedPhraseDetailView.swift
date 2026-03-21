import SwiftUI
import SwiftData

struct SavedPhraseDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let savedPhrase: SavedPhrase

    @State private var showDeleteConfirmation = false
    @StateObject private var pronunciationService = PronunciationService()

    var body: some View {
        List {
            Section("Target") {
                Text(savedPhrase.targetText)
                    .font(.title3)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityLabel("Saved phrase: \(savedPhrase.targetText)")
            }

            Section("Audio") {
                Button {
                    pronunciationService.play(
                        text: savedPhrase.targetText,
                        destinationName: savedPhrase.destinationName
                    )
                } label: {
                    Label("Play pronunciation", systemImage: "speaker.wave.2.fill")
                }
                .accessibilityLabel("Play pronunciation")
                .accessibilityHint("Speaks the saved phrase aloud.")

                if pronunciationService.isSpeaking {
                    Button("Stop playback") {
                        pronunciationService.stop()
                    }
                    .accessibilityLabel("Stop pronunciation")
                    .accessibilityHint("Stops audio playback.")
                }
            }

            Section("Meaning") {
                Text(savedPhrase.englishMeaning)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Section("Context") {
                Text(savedPhrase.destinationName)
                Text(savedPhrase.situationTitle)
            }

            Section("Saved") {
                Text(savedPhrase.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
            }

            Section {
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Text("Delete Phrase")
                }
                .accessibilityLabel("Delete saved phrase")
                .accessibilityHint("Removes this phrase from your phrasebook.")
            }
        }
        .navigationTitle("Saved Phrase")
        .confirmationDialog(
            "Delete this saved phrase?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                deleteSavedPhrase()
            }
            Button("Cancel", role: .cancel) {}
        }
        .onDisappear {
            pronunciationService.stop()
        }
    }

    private func deleteSavedPhrase() {
        modelContext.delete(savedPhrase)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            assertionFailure("Failed to delete saved phrase: \(error.localizedDescription)")
        }
    }
}
