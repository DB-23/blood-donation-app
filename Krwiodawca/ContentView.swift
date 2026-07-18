import SwiftUI

struct ContentView: View {
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
    }
}

#Preview {
    ContentView()
        .environmentObject(DonorSettings())
        .modelContainer(for: Donation.self, inMemory: true)
}
