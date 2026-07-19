import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var donorSettings: DonorSettings

    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Pulpit", systemImage: "house.fill") }

            StatsView()
                .tabItem { Label("Statystyki", systemImage: "chart.bar.fill") }

            AchievementsView()
                .tabItem { Label("Osiągnięcia", systemImage: "rosette") }

            HistoryView()
                .tabItem { Label("Historia", systemImage: "list.bullet.rectangle") }

            RCKiKListView()
                .tabItem { Label("RCKiK", systemImage: "building.2.fill") }
        }
        .tint(.red)
        .preferredColorScheme(donorSettings.theme.colorScheme)
    }
}

#Preview {
    ContentView()
        .environmentObject(DonorSettings())
        .modelContainer(for: Donation.self, inMemory: true)
}
