import Foundation
import SwiftData

enum SeedContentService {
    static func upsertBarcelonaSeed(in modelContext: ModelContext) throws {
        let dto = try loadBarcelonaSeedDTO()

        let destinationName = dto.destination.trimmingCharacters(in: .whitespacesAndNewlines)
        let targetLanguage = dto.languages.first ?? "Spanish"

        let trip = try upsertTrip(
            destinationName: destinationName,
            baseLanguage: "English",
            targetLanguage: targetLanguage,
            in: modelContext
        )

        for (index, situationDTO) in dto.situations.enumerated() {
            let situation = try upsertSituation(
                trip: trip,
                title: situationDTO.title,
                sortOrder: index,
                in: modelContext
            )

            for phraseDTO in situationDTO.phrases {
                try upsertPhrase(
                    situation: situation,
                    phrase: phraseDTO,
                    in: modelContext
                )
            }
        }

        try modelContext.save()
    }

    static func loadBarcelonaSeedDTO() throws -> SeedContentDTO {
        let candidateURLs = [
            Bundle.main.url(forResource: "barcelona_seed_v1", withExtension: "json"),
            Bundle.main.url(forResource: "barcelona_seed_v1", withExtension: "json", subdirectory: "SeedContent"),
            Bundle.main.url(forResource: "barcelona_seed_v1", withExtension: "json", subdirectory: "Resources/SeedContent")
        ]

        guard let url = candidateURLs.compactMap({ $0 }).first else {
            throw SeedContentError.missingSeedFile
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(SeedContentDTO.self, from: data)
    }

    private static func upsertTrip(
        destinationName: String,
        baseLanguage: String,
        targetLanguage: String,
        in modelContext: ModelContext
    ) throws -> Trip {
        let descriptor = FetchDescriptor<Trip>(
            predicate: #Predicate { trip in
                trip.destinationName == destinationName
            }
        )

        if let existing = try modelContext.fetch(descriptor).first {
            existing.baseLanguage = baseLanguage
            existing.targetLanguage = targetLanguage
            return existing
        }

        let newTrip = Trip(
            destinationName: destinationName,
            baseLanguage: baseLanguage,
            targetLanguage: targetLanguage
        )
        modelContext.insert(newTrip)
        return newTrip
    }

    private static func upsertSituation(
        trip: Trip,
        title: String,
        sortOrder: Int,
        in modelContext: ModelContext
    ) throws -> Situation {
        let tripID = trip.id
        let descriptor = FetchDescriptor<Situation>(
            predicate: #Predicate { situation in
                situation.trip.id == tripID && situation.title == title
            }
        )

        if let existing = try modelContext.fetch(descriptor).first {
            existing.sortOrder = sortOrder
            return existing
        }

        let newSituation = Situation(trip: trip, title: title, sortOrder: sortOrder)
        modelContext.insert(newSituation)
        return newSituation
    }

    private static func upsertPhrase(
        situation: Situation,
        phrase: PhraseDTO,
        in modelContext: ModelContext
    ) throws {
        let situationID = situation.id
        let targetText = phrase.targetText
        let descriptor = FetchDescriptor<Phrase>(
            predicate: #Predicate { existing in
                existing.situation.id == situationID && existing.targetText == targetText
            }
        )

        if let existing = try modelContext.fetch(descriptor).first {
            existing.englishMeaning = phrase.englishMeaning
            existing.notes = phrase.notes
            existing.tagsCSV = phrase.tags.joined(separator: ",")
            return
        }

        let newPhrase = Phrase(
            situation: situation,
            targetText: phrase.targetText,
            englishMeaning: phrase.englishMeaning,
            notes: phrase.notes,
            tagsCSV: phrase.tags.joined(separator: ",")
        )
        modelContext.insert(newPhrase)
    }
}

enum SeedContentError: LocalizedError {
    case missingSeedFile

    var errorDescription: String? {
        switch self {
        case .missingSeedFile:
            return "Could not find barcelona_seed_v1.json in app bundle resources."
        }
    }
}

struct SeedContentDTO: Decodable {
    let destination: String
    let languages: [String]
    let situations: [SituationDTO]
}

struct SituationDTO: Decodable {
    let title: String
    let phrases: [PhraseDTO]
}

struct PhraseDTO: Decodable {
    let targetText: String
    let englishMeaning: String
    let notes: String?
    let tags: [String]

    private enum CodingKeys: String, CodingKey {
        case targetText
        case englishMeaning
        case notes
        case tags
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        targetText = try container.decode(String.self, forKey: .targetText)
        englishMeaning = try container.decode(String.self, forKey: .englishMeaning)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
    }
}
