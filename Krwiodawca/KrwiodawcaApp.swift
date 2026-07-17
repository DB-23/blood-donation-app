import SwiftUI
import SwiftData

@main
struct KrwiodawcaApp: App {
    @StateObject private var donorSettings = DonorSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(donorSettings)
        }
        .modelContainer(for: Donation.self)
    }
}
