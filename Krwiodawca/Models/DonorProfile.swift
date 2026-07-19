import Foundation
import Combine
import SwiftUI

enum DonorSex: String, CaseIterable, Codable {
    case male = "Mężczyzna"
    case female = "Kobieta"
}

enum AppTheme: String, CaseIterable, Codable {
    case system = "Systemowy"
    case light = "Jasny"
    case dark = "Ciemny"

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

/// Dorobek dawcy sprzed instalacji aplikacji (np. z papierowej legitymacji HDK),
/// wprowadzany ręcznie zamiast pojedynczej donacji po donacji.
struct ComponentBaseline: Codable, Equatable {
    var count: Int = 0
    var volumeMl: Int = 0
    var lastDonationDate: Date?
}

/// Profil dawcy trzymany w UserDefaults — wpływa na reguły kwalifikacji
/// (limity donacji) i progi odznak "Zasłużony Honorowy Dawca Krwi".
final class DonorSettings: ObservableObject {
    @Published var sex: DonorSex {
        didSet { UserDefaults.standard.set(sex.rawValue, forKey: "donorSex") }
    }
    @Published var name: String {
        didSet { UserDefaults.standard.set(name, forKey: "donorName") }
    }
    @Published var bloodType: String {
        didSet { UserDefaults.standard.set(bloodType, forKey: "donorBloodType") }
    }
    @Published var theme: AppTheme {
        didSet { UserDefaults.standard.set(theme.rawValue, forKey: "donorTheme") }
    }
    /// Klucz to `BloodComponentType.rawValue`.
    @Published var baselines: [String: ComponentBaseline] {
        didSet {
            if let data = try? JSONEncoder().encode(baselines) {
                UserDefaults.standard.set(data, forKey: "donorBaselines")
            }
        }
    }

    static let bloodTypes = ["Nieznana", "0 Rh+", "0 Rh-", "A Rh+", "A Rh-", "B Rh+", "B Rh-", "AB Rh+", "AB Rh-"]

    init() {
        let sexRaw = UserDefaults.standard.string(forKey: "donorSex") ?? DonorSex.male.rawValue
        self.sex = DonorSex(rawValue: sexRaw) ?? .male
        self.name = UserDefaults.standard.string(forKey: "donorName") ?? ""
        self.bloodType = UserDefaults.standard.string(forKey: "donorBloodType") ?? "Nieznana"
        let themeRaw = UserDefaults.standard.string(forKey: "donorTheme") ?? AppTheme.system.rawValue
        self.theme = AppTheme(rawValue: themeRaw) ?? .system
        if let data = UserDefaults.standard.data(forKey: "donorBaselines"),
           let decoded = try? JSONDecoder().decode([String: ComponentBaseline].self, from: data) {
            self.baselines = decoded
        } else {
            self.baselines = [:]
        }
    }

    func baseline(for component: BloodComponentType) -> ComponentBaseline {
        baselines[component.rawValue] ?? ComponentBaseline()
    }

    func updateBaseline(for component: BloodComponentType, _ update: (inout ComponentBaseline) -> Void) {
        var current = baseline(for: component)
        update(&current)
        baselines[component.rawValue] = current
    }

    var totalBaselineCount: Int {
        baselines.values.reduce(0) { $0 + $1.count }
    }

    var totalBaselineVolumeMl: Int {
        baselines.values.reduce(0) { $0 + $1.volumeMl }
    }
}
