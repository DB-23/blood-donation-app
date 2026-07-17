import Foundation
import SwiftData

@Model
final class Donation {
    var id: UUID
    var date: Date
    var componentRaw: String
    var volumeMl: Int
    var location: String
    var notes: String

    var component: BloodComponentType {
        get { BloodComponentType(rawValue: componentRaw) ?? .wholeBlood }
        set { componentRaw = newValue.rawValue }
    }

    init(
        date: Date = .now,
        component: BloodComponentType = .wholeBlood,
        volumeMl: Int? = nil,
        location: String = "",
        notes: String = ""
    ) {
        self.id = UUID()
        self.date = date
        self.componentRaw = component.rawValue
        self.volumeMl = volumeMl ?? component.defaultVolumeMl
        self.location = location
        self.notes = notes
    }
}
