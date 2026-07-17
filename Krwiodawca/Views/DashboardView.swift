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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
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
