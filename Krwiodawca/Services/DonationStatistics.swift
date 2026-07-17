import Foundation

struct ComponentBreakdown: Identifiable {
    var id: BloodComponentType { component }
    let component: BloodComponentType
    let count: Int
    let volumeMl: Int
}

struct YearlyBreakdown: Identifiable {
    var id: Int { year }
    let year: Int
    let count: Int
    let volumeMl: Int
}

/// Wylicza zagregowane statystyki na podstawie listy donacji.
enum DonationStatistics {
    static func totalVolumeMl(_ donations: [Donation]) -> Int {
        donations.reduce(0) { $0 + $1.volumeMl }
    }

    static func totalLiters(_ donations: [Donation]) -> Double {
        Double(totalVolumeMl(donations)) / 1000.0
    }

    /// Szacowana liczba osób, którym mogła pomóc oddana krew pełna
    /// (przyjmując, że jedna donacja krwi pełnej może uratować do 3 osób).
    static func estimatedLivesHelped(_ donations: [Donation]) -> Int {
        donations.filter { $0.component == .wholeBlood }.count * 3
    }

    static func byComponent(_ donations: [Donation]) -> [ComponentBreakdown] {
        BloodComponentType.allCases.map { component in
            let matching = donations.filter { $0.component == component }
            return ComponentBreakdown(
                component: component,
                count: matching.count,
                volumeMl: matching.reduce(0) { $0 + $1.volumeMl }
            )
        }
    }

    static func byYear(_ donations: [Donation]) -> [YearlyBreakdown] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: donations) { calendar.component(.year, from: $0.date) }
        return grouped.map { year, items in
            YearlyBreakdown(year: year, count: items.count, volumeMl: items.reduce(0) { $0 + $1.volumeMl })
        }.sorted { $0.year < $1.year }
    }

    /// Średnia liczba dni między kolejnymi donacjami (dowolnego typu).
    static func averageIntervalDays(_ donations: [Donation]) -> Double? {
        let sorted = donations.sorted { $0.date < $1.date }
        guard sorted.count >= 2 else { return nil }
        let calendar = Calendar.current
        var totalDays = 0
        for i in 1..<sorted.count {
            let days = calendar.dateComponents([.day], from: sorted[i - 1].date, to: sorted[i].date).day ?? 0
            totalDays += days
        }
        return Double(totalDays) / Double(sorted.count - 1)
    }
}
