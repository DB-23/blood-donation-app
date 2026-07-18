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
/// Progi i uprawnienia bazują na obowiązujących przepisach (Ustawa z dnia
/// 22 sierpnia 1997 r. o publicznej służbie krwi; rozporządzenia MZ ws.
/// odznak ZHDK i odznaki "Zasłużony dla Zdrowia Narodu"), zweryfikowanych
/// na podstawie https://krwiodawcy.org/odznaki/odznaki-zhdk i
/// https://krwiodawcy.org/korzysci-z-hdk, uzupełnionych o dodatkowe
/// kamienie milowe motywacyjne (10/25/50 donacji — nieoficjalne).
enum AchievementsCatalog {
    static func achievements(for sex: DonorSex) -> [Achievement] {
        let isMale = sex == .male
        return [
            Achievement(
                id: "hdk",
                title: "Honorowy Dawca Krwi",
                icon: "heart.text.square.fill",
                requirement: .donations(1),
                benefits: [
                    "Tytuł i legitymacja \"Honorowego Dawcy Krwi\" — przysługuje już po pierwszej donacji",
                    "Posiłek regeneracyjny o wartości 4500 kcal",
                    "Dzień wolny od pracy w dniu oddania krwi i dniu następnym (z zachowaniem wynagrodzenia)",
                    "Ulga podatkowa w PIT — 130 zł za każdy oddany litr krwi (do 6% dochodu)",
                    "Zwrot kosztów dojazdu do punktu poboru krwi",
                    "Bezpłatne wyniki badań laboratoryjnych"
                ]
            ),
            Achievement(
                id: "brazowy",
                title: "Zasłużony HDK — Brąz (III st.)",
                icon: "medal.fill",
                requirement: .liters(isMale ? 6 : 5),
                benefits: [
                    "Tytuł i brązowa odznaka \"Zasłużony Honorowy Dawca Krwi III stopnia\"",
                    "Zniżki lub bezpłatne wybrane leki za okazaniem recepty z adnotacją \"ZK\"",
                    "Świadczenia zdrowotne i usługi farmaceutyczne poza kolejnością"
                ]
            ),
            Achievement(
                id: "srebrny",
                title: "Zasłużony HDK — Srebro (II st.)",
                icon: "medal.fill",
                requirement: .liters(isMale ? 12 : 10),
                benefits: [
                    "Tytuł i srebrna odznaka \"Zasłużony Honorowy Dawca Krwi II stopnia\"",
                    "Zniżki lub bezpłatne wybrane leki za okazaniem recepty z adnotacją \"ZK\"",
                    "Świadczenia zdrowotne poza kolejnością, zniżki w komunikacji miejskiej w wybranych miastach"
                ]
            ),
            Achievement(
                id: "zloty",
                title: "Zasłużony HDK — Złoto (I st.)",
                icon: "medal.fill",
                requirement: .liters(isMale ? 18 : 15),
                benefits: [
                    "Tytuł i złota odznaka \"Zasłużony Honorowy Dawca Krwi I stopnia\"",
                    "Zniżki lub bezpłatne wybrane leki za okazaniem recepty z adnotacją \"ZK\"",
                    "Świadczenia zdrowotne poza kolejnością, zniżki w komunikacji miejskiej w wybranych miastach",
                    "Rabaty partnerskie (m.in. paliwo, inicjatywa \"Dawcom w Darze\")"
                ]
            ),
            Achievement(
                id: "zdzn",
                title: "HDK — Zasłużony dla Zdrowia Narodu",
                icon: "crown.fill",
                requirement: .liters(20),
                benefits: [
                    "Najwyższe krajowe wyróżnienie dla honorowych dawców krwi",
                    "Odznaka i legitymacja \"Honorowy Dawca Krwi – Zasłużony dla Zdrowia Narodu\" nadawana przez Ministra Zdrowia",
                    "Możliwość ubiegania się o ordery i odznaczenia państwowe",
                    "Próg 20 litrów jest jednakowy dla kobiet i mężczyzn"
                ]
            ),
            Achievement(
                id: "ten",
                title: "10 Donacji",
                icon: "10.circle.fill",
                requirement: .donations(10),
                benefits: ["Osobisty kamień milowy (nieoficjalny) — 10 oddań krwi lub jej składników."]
            ),
            Achievement(
                id: "twentyFive",
                title: "25 Donacji",
                icon: "star.circle.fill",
                requirement: .donations(25),
                benefits: ["Osobisty kamień milowy (nieoficjalny) — 25 oddań."]
            ),
            Achievement(
                id: "fifty",
                title: "50 Donacji",
                icon: "flame.fill",
                requirement: .donations(50),
                benefits: ["Osobisty kamień milowy (nieoficjalny) — 50 oddań. Wybitna postawa!"]
            )
        ]
    }
}
