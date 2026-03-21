import Foundation
import SwiftData

@Model
final class SavedPlace {
    var id: UUID
    var name: String
    var categoryRaw: String?
    var destinationName: String
    var latitude: Double
    var longitude: Double
    var createdAt: Date

    var category: POICategory? {
        get {
            guard let categoryRaw else { return nil }
            return POICategory(rawValue: categoryRaw)
        }
        set {
            categoryRaw = newValue?.rawValue
        }
    }

    init(
        id: UUID = UUID(),
        name: String,
        category: POICategory? = nil,
        destinationName: String = "",
        latitude: Double,
        longitude: Double,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.categoryRaw = category?.rawValue
        self.destinationName = destinationName
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
    }
}
