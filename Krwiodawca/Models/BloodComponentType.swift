import SwiftUI

enum BloodComponentType: String, CaseIterable, Codable, Identifiable {
    case wholeBlood = "Krew pełna"
    case plasma = "Osocze"
    case platelets = "Płytki krwi"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .wholeBlood: return "drop.fill"
        case .plasma: return "flask.fill"
        case .platelets: return "circle.hexagongrid.fill"
        }
    }

    var color: Color {
        switch self {
        case .wholeBlood: return .red
        case .plasma: return .yellow
        case .platelets: return .orange
        }
    }

    /// Typowa objętość jednorazowej donacji w mililitrach (wartość orientacyjna).
    var defaultVolumeMl: Int {
        switch self {
        case .wholeBlood: return 450
        case .plasma: return 600
        case .platelets: return 300
        }
    }
}
