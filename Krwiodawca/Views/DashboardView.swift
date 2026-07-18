import SwiftUI
import SwiftData

struct DashboardView: View {
    @EnvironmentObject private var donorSettings: DonorSettings
    @Query(sort: \Donation.date, order: .reverse) private var donations: [Donation]
    @State private var showingAddSheet = false
    @State private var showingProfileSheet = false

    private var eligibilityStatuses: [EligibilityStatus] {
        EligibilityCalculator.allStatuses(donations: donations, sex: donorSettings.sex)
    }

    /// Najbliższy termin, w którym można oddać krew lub dowolny jej składnik.
    private var nextDonationDateText: String {
        if eligibilityStatuses.contains(where: { $0.isEligibleNow }) {
            return "Już dziś"
        }
        guard let earliest = eligibilityStatuses.compactMap({ $0.nextEligibleDate }).min() else {
            return "—"
        }
        return earliest.formatted(date: .abbreviated, time: .omitted)
    }

    private var nextDonationSubtitle: String? {
        if let eligibleNow = eligibilityStatuses.first(where: { $0.isEligibleNow }) {
            return eligibleNow.component.rawValue
        }
        guard let soonest = eligibilityStatuses
            .compactMap({ status -> (EligibilityStatus, Date)? in
                guard let date = status.nextEligibleDate else { return nil }
                return (status, date)
            })
            .min(by: { $0.1 < $1.1 }) else {
            return nil
        }
        return soonest.0.component.rawValue
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        StatCard(
                            title: "Następna możliwa donacja",
                            value: nextDonationDateText,
                            subtitle: nextDonationSubtitle,
                            icon: "calendar.badge.clock",
                            tint: .green
                        )
                        StatCard(
                            title: "Łącznie donacji",
                            value: "\(donations.count)",
                            icon: "drop.fill"
                        )
                        StatCard(
                            title: "Oddana krew",
                            value: String(format: "%.1f l", DonationStatistics.totalLiters(donations)),
                            icon: "chart.bar.fill",
                            tint: .orange
                        )
                        StatCard(
                            title: "Pomożono osobom",
                            value: "~\(DonationStatistics.estimatedLivesHelped(donations))",
                            subtitle: "orientacyjnie",
                            icon: "heart.fill",
                            tint: .pink
                        )
                        StatCard(
                            title: "Ostatnia donacja",
                            value: donations.first.map { $0.date.formatted(date: .abbreviated, time: .omitted) } ?? "—",
                            icon: "calendar",
                            tint: .blue
                        )
                    }

                    Text("Kiedy możesz oddać krew")
                        .font(.title3.bold())
                        .padding(.top, 8)

                    VStack(spacing: 12) {
                        ForEach(eligibilityStatuses) { status in
                            EligibilityCard(status: status)
                        }
                    }

                    Text("Reguły są orientacyjne (na podstawie wytycznych polskich RCKiK) — przed donacją zawsze potwierdź kwalifikację z lekarzem w punkcie poboru krwi.")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .padding(.top, 4)
                }
                .padding()
            }
            .navigationTitle("Pulpit")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingProfileSheet = true
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddDonationView()
            }
            .sheet(isPresented: $showingProfileSheet) {
                ProfileSettingsView()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(donorSettings.name.isEmpty ? "Cześć!" : "Cześć, \(donorSettings.name)!")
                .font(.largeTitle.bold())
            Text("Dziękujemy, że ratujesz życie.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(DonorSettings())
        .modelContainer(for: Donation.self, inMemory: true)
}
