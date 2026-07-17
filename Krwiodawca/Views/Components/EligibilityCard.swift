import SwiftUI

struct EligibilityCard: View {
    let status: EligibilityStatus

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "pl_PL")
        return formatter
    }()

    private var daysRemaining: Int? {
        guard let next = status.nextEligibleDate else { return nil }
        let days = Calendar.current.dateComponents([.day], from: .now, to: next).day ?? 0
        return max(days, 0)
    }

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(status.component.color.opacity(0.15))
                    .frame(width: 52, height: 52)
                Image(systemName: status.component.icon)
                    .foregroundStyle(status.component.color)
                    .font(.title3)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(status.component.rawValue)
                    .font(.headline)

                if status.isEligibleNow {
                    Label("Możesz oddać już teraz", systemImage: "checkmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.green)
                } else if let next = status.nextEligibleDate {
                    Text("Od \(Self.dateFormatter.string(from: next))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if let daysRemaining {
                        Text("Pozostało \(daysRemaining) dni")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                } else {
                    Text("Brak danych — dodaj pierwszą donację")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text("\(status.donationsThisYear)/\(status.annualLimit) w tym roku")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer()
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    EligibilityCard(status: EligibilityStatus(
        component: .wholeBlood,
        lastDonationDate: .now,
        nextEligibleDate: Calendar.current.date(byAdding: .day, value: 40, to: .now),
        isEligibleNow: false,
        donationsThisYear: 2,
        annualLimit: 6
    ))
    .padding()
}
