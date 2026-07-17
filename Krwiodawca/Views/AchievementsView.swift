import SwiftUI
import SwiftData

struct AchievementsView: View {
    @EnvironmentObject private var donorSettings: DonorSettings
    @Query private var donations: [Donation]
    @State private var selectedAchievement: Achievement?

    private var totalDonations: Int { donations.count }
    private var totalLiters: Double { DonationStatistics.totalLiters(donations) }

    private var achievements: [Achievement] {
        AchievementsCatalog.achievements(for: donorSettings.sex)
    }

    private var unlockedCount: Int {
        achievements.filter { $0.isUnlocked(totalDonations: totalDonations, totalLiters: totalLiters) }.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Roadmapa osiągnięć")
                            .font(.largeTitle.bold())
                        Text("Odblokowano \(unlockedCount) z \(achievements.count)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 4)

                    ForEach(achievements) { achievement in
                        Button {
                            selectedAchievement = achievement
                        } label: {
                            AchievementRow(
                                achievement: achievement,
                                totalDonations: totalDonations,
                                totalLiters: totalLiters
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Osiągnięcia")
            .sheet(item: $selectedAchievement) { achievement in
                AchievementDetailView(
                    achievement: achievement,
                    totalDonations: totalDonations,
                    totalLiters: totalLiters
                )
            }
        }
    }
}

private struct AchievementDetailView: View {
    let achievement: Achievement
    let totalDonations: Int
    let totalLiters: Double
    @Environment(\.dismiss) private var dismiss

    private var isUnlocked: Bool {
        achievement.isUnlocked(totalDonations: totalDonations, totalLiters: totalLiters)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: isUnlocked ? achievement.icon : "lock.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(isUnlocked ? .yellow : .secondary)
                    .padding(.top, 24)

                Text(achievement.title)
                    .font(.title.bold())

                Text(isUnlocked ? "Zdobyto!" : "Wymagane: \(achievement.requirementLabel)")
                    .foregroundStyle(isUnlocked ? .green : .secondary)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Benefity")
                        .font(.headline)
                    ForEach(achievement.benefits, id: \.self) { benefit in
                        Label(benefit, systemImage: "checkmark.circle")
                            .font(.subheadline)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Zamknij") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    AchievementsView()
        .environmentObject(DonorSettings())
        .modelContainer(for: Donation.self, inMemory: true)
}
