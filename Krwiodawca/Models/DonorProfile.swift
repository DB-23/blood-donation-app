import Foundation
import Combine

enum DonorSex: String, CaseIterable, Codable {
    case male = "Mężczyzna"
    case female = "Kobieta"
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

    static let bloodTypes = ["Nieznana", "0 Rh+", "0 Rh-", "A Rh+", "A Rh-", "B Rh+", "B Rh-", "AB Rh+", "AB Rh-"]

    init() {
        let sexRaw = UserDefaults.standard.string(forKey: "donorSex") ?? DonorSex.male.rawValue
        self.sex = DonorSex(rawValue: sexRaw) ?? .male
        self.name = UserDefaults.standard.string(forKey: "donorName") ?? ""
        self.bloodType = UserDefaults.standard.string(forKey: "donorBloodType") ?? "Nieznana"
    }
}
