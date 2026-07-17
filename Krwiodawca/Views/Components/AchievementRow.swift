import SwiftUI

struct AchievementRow: View {
    let achievement: Achievement
    let totalDonations: Int
    let totalLiters: Double

    private var progress: Double {
        achievement.progress(totalDonations: totalDonations, totalLiters: totalLiters)
    }

    private var isUnlocked: Bool {
        achievement.isUnlocked(totalDonations: totalDonations, totalLiters: totalLiters)
    }

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color.yellow.opacity(0.25) : Color.gray.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: isUnlocked ? achievement.icon : "lock.fill")
                    .foregroundStyle(isUnlocked ? .yellow : .secondary)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundStyle(isUnlocked ? .primary : .secondary)

                ProgressView(value: progress)
                    .tint(isUnlocked ? .yellow : .red)

                Text(achievement.requirementLabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isUnlocked {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    AchievementRow(
        achievement: AchievementsCatalog.achievements(for: .male)[1],
        totalDonations: 4,
        totalLiters: 1.8
    )
    .padding()
}
