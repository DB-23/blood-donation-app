import Foundation

struct EligibilityStatus: Identifiable {
    var id: BloodComponentType { component }
    let component: BloodComponentType
    let lastDonationDate: Date?
    let nextEligibleDate: Date?
    let isEligibleNow: Bool
    let donationsThisYear: Int
    let annualLimit: Int
}

/// Uproszczone reguły kwalifikacji oparte na wytycznych polskich RCKiK.
/// Wartości orientacyjne — przed oddaniem krwi zawsze warto potwierdzić
/// aktualne przepisy i stan zdrowia z lekarzem w punkcie poboru krwi.
enum EligibilityCalculator {
    static func minimumIntervalDays(for component: BloodComponentType) -> Int {
        switch component {
        case .wholeBlood: return 56
        case .plasma: return 14
        case .platelets: return 28
        }
    }

    static func annualLimit(for component: BloodComponentType, sex: DonorSex) -> Int {
        switch component {
        case .wholeBlood: return sex == .male ? 6 : 4
        case .plasma: return 24
        case .platelets: return 12
        }
    }

    static func status(
        for component: BloodComponentType,
        donations: [Donation],
        sex: DonorSex,
        referenceDate: Date = .now,
        baselineLastDonationDate: Date? = nil
    ) -> EligibilityStatus {
        let calendar = Calendar.current
        let componentDonations = donations
            .filter { $0.component == component }
            .sorted { $0.date > $1.date }

        // Data ostatniej donacji z realnych wpisów lub, jeśli jest nowsza,
        // z ręcznie wprowadzonego stanu początkowego (patrz DonorSettings.baselines).
        // Roczny limit poniżej liczy tylko realne wpisy — stan początkowy nie ma
        // rozbicia na poszczególne donacje w oknie 365 dni, to uproszczenie.
        let lastDate = [componentDonations.first?.date, baselineLastDonationDate].compactMap { $0 }.max()
        let interval = minimumIntervalDays(for: component)
        let limit = annualLimit(for: component, sex: sex)

        let oneYearAgo = calendar.date(byAdding: .day, value: -365, to: referenceDate) ?? referenceDate
        let donationsInWindow = componentDonations.filter { $0.date >= oneYearAgo }
        let donationsThisYear = donationsInWindow.count

        let intervalNextDate = lastDate.flatMap { calendar.date(byAdding: .day, value: interval, to: $0) }
        let intervalOK = intervalNextDate == nil || intervalNextDate! <= referenceDate
        let limitOK = donationsThisYear < limit

        var candidateDate = intervalNextDate
        if !limitOK, let oldestInWindow = donationsInWindow.last?.date {
            let limitFreeDate = calendar.date(byAdding: .day, value: 365, to: oldestInWindow)
            candidateDate = [candidateDate, limitFreeDate].compactMap { $0 }.max()
        }

        let isEligible = intervalOK && limitOK

        return EligibilityStatus(
            component: component,
            lastDonationDate: lastDate,
            nextEligibleDate: isEligible ? nil : candidateDate,
            isEligibleNow: isEligible,
            donationsThisYear: donationsThisYear,
            annualLimit: limit
        )
    }

    static func allStatuses(
        donations: [Donation],
        sex: DonorSex,
        referenceDate: Date = .now,
        donorSettings: DonorSettings? = nil
    ) -> [EligibilityStatus] {
        BloodComponentType.allCases.map {
            status(
                for: $0,
                donations: donations,
                sex: sex,
                referenceDate: referenceDate,
                baselineLastDonationDate: donorSettings?.baseline(for: $0).lastDonationDate
            )
        }
    }
}
