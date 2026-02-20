import SwiftUI
import SwiftData

struct SituationDetailView: View {
    let situation: Situation
    let destinationName: String

    @Query private var phrases: [Phrase]

    init(situation: Situation, destinationName: String) {
        self.situation = situation
        self.destinationName = destinationName
        let situationID = situation.id
        _phrases = Query(
            filter: #Predicate<Phrase> { phrase in
                phrase.situation.id == situationID
            },
            sort: [SortDescriptor(\Phrase.targetText, order: .forward)]
        )
    }

    var body: some View {
        List {
            ForEach(phrases) { phrase in
                NavigationLink {
                    PhraseDetailView(
                        phrase: phrase,
                        destinationName: destinationName,
                        situationTitle: situation.title
                    )
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(phrase.targetText)
                        Text(phrase.englishMeaning)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle(situation.title)
    }
}
