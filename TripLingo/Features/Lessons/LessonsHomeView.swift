import SwiftUI
import SwiftData

struct LessonsHomeView: View {
    @Query(sort: [SortDescriptor(\Trip.createdAt, order: .forward)])
    private var trips: [Trip]

    @Query(sort: [SortDescriptor(\Situation.sortOrder, order: .forward), SortDescriptor(\Situation.title, order: .forward)])
    private var situations: [Situation]

    private var barcelonaTrip: Trip? {
        trips.first(where: { $0.destinationName.caseInsensitiveCompare("Barcelona") == .orderedSame }) ?? trips.first
    }

    private var barcelonaSituations: [Situation] {
        guard let trip = barcelonaTrip else { return [] }
        return situations.filter { $0.trip.id == trip.id }
    }

    var body: some View {
        List {
            if let trip = barcelonaTrip {
                Section {
                    ForEach(barcelonaSituations) { situation in
                        NavigationLink {
                            SituationDetailView(situation: situation, destinationName: trip.destinationName)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(situation.title)
                                Text("Micro-lesson")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                } header: {
                    Text(trip.destinationName)
                }
            } else {
                ContentUnavailableView(
                    "No Lessons Yet",
                    systemImage: "book.closed",
                    description: Text("Seed content will appear after app startup.")
                )
            }
        }
        .navigationTitle("Lessons")
    }
}
