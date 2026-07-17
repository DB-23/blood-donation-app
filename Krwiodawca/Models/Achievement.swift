import Foundation

struct Achievement: Identifiable {
    enum Requirement {
        case donations(Int)
        case liters(Double)
    }

    let id: String
    let title: String
    let icon: String
    let requirement: Requirement
    let benefits: [String]

    func progress(totalDonations: Int, totalLiters: Double) -> Double {
        switch requirement {
        case .donations(let count):
            guard count > 0 else { return 1 }
            return min(Double(totalDonations) / Double(count), 1)
        case .liters(let liters):
            guard liters > 0 else { return 1 }
            return min(totalLiters / liters, 1)
        }
    }

    func isUnlocked(totalDonations: Int, totalLiters: Double) -> Bool {
        progress(totalDonations: totalDonations, totalLiters: totalLiters) >= 1
    }

    var requirementLabel: String {
        switch requirement {
        case .donations(let count):
            return "\(count) donacji"
        case .liters(let liters):
            return "\(liters.formatted(.number.precision(.fractionLength(0...1)))) l oddanej krwi"
        }
    }
}

/// Katalog osiągnięć — kolejność wyznacza "roadmapę" w AchievementsView.
/// Progi bazują na realnych regułach polskiego honorowego krwiodawstwa
/// (tytuł HDK po 3 donacjach, odznaki "Zasłużony HDK" wg litrów oddanej krwi),
/// uzupełnionych o dodatkowe kamienie milowe motywacyjne.
enum AchievementsCatalog {
    static func achievements(for sex: DonorSex) -> [Achievement] {
        let isMale = sex == .male
        return [
            Achievement(
                id: "first",
                title: "Pierwszy Krok",
                icon: "drop.circle.fill",
                requirement: .donations(1),
                benefits: ["Twoja pierwsza donacja — dołączasz do grona honorowych dawców krwi."]
            ),
            Achievement(
                id: "hdk",
                title: "Honorowy Dawca Krwi",
                icon: "heart.text.square.fill",
                requirement: .donations(3),
                benefits: [
                    "Legitymacja Honorowego Dawcy Krwi (HDK)",
                    "Dzień wolny od pracy w dniu oddania krwi i dniu następnym",
                    "Posiłek regeneracyjny (ekwiwalent ok. 4500 kcal)",
                    "Zwrot kosztów dojazdu do punktu poboru krwi"
                ]
            ),
            Achievement(
                id: "brazowy",
                title: "Zasłużony HDK — Brąz",
                icon: "medal.fill",
                requirement: .liters(isMale ? 6 : 5),
                benefits: [
                    "Odznaka \"Zasłużony Honorowy Dawca Krwi\" — stopień brązowy",
                    "Prawo do ulgi w podatku PIT za oddaną krew"
                ]
            ),
            Achievement(
                id: "srebrny",
                title: "Zasłużony HDK — Srebro",
                icon: "medal.fill",
                requirement: .liters(isMale ? 12 : 10),
                benefits: [
                    "Odznaka \"Zasłużony Honorowy Dawca Krwi\" — stopień srebrny",
                    "Ulgowe przejazdy komunikacją miejską w wybranych miastach"
                ]
            ),
            Achievement(
                id: "zloty",
                title: "Zasłużony HDK — Złoto",
                icon: "medal.fill",
                requirement: .liters(isMale ? 18 : 15),
                benefits: [
                    "Odznaka \"Zasłużony Honorowy Dawca Krwi\" — stopień złoty",
                    "Możliwość ubiegania się o tytuł \"Zasłużony Honorowy Dawca Krwi\"",
                    "Wybrane świadczenia zdrowotne poza kolejnością"
                ]
            ),
            Achievement(
                id: "ten",
                title: "10 Donacji",
                icon: "10.circle.fill",
                requirement: .donations(10),
                benefits: ["Osobisty kamień milowy — 10 oddań krwi lub jej składników."]
            ),
            Achievement(
                id: "twentyFive",
                title: "25 Donacji",
                icon: "star.circle.fill",
                requirement: .donations(25),
                benefits: ["Osobisty kamień milowy — 25 oddań."]
            ),
            Achievement(
                id: "fifty",
                title: "50 Donacji",
                icon: "crown.fill",
                requirement: .donations(50),
                benefits: ["Osobisty kamień milowy — 50 oddań. Wybitna postawa!"]
            )
        ]
    }
}
