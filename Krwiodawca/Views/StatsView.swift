import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Query(sort: \Donation.date) private var donations: [Donation]

    private var byComponent: [ComponentBreakdown] {
        DonationStatistics.byComponent(donations)
    }

    private var byYear: [YearlyBreakdown] {
        DonationStatistics.byYear(donations)
    }

    private var averageInterval: Double? {
        DonationStatistics.averageIntervalDays(donations)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if donations.isEmpty {
                    ContentUnavailableView(
                        "Brak danych",
                        systemImage: "chart.bar.xaxis",
                        description: Text("Dodaj swoją pierwszą donację, aby zobaczyć statystyki.")
                    )
                    .padding(.top, 60)
                } else {
                    VStack(alignment: .leading, spacing: 24) {
                        section(title: "Donacje w czasie") {
                            Chart(byYear) { item in
                                BarMark(
                                    x: .value("Rok", String(item.year)),
                                    y: .value("Liczba donacji", item.count)
                                )
                                .foregroundStyle(Color.red.gradient)
                                .cornerRadius(6)
                            }
                            .frame(height: 200)
                        }

                        section(title: "Podział na składniki krwi") {
                            Chart(byComponent.filter { $0.count > 0 }) { item in
                                SectorMark(
                                    angle: .value("Liczba", item.count),
                                    innerRadius: .ratio(0.6),
                                    angularInset: 1.5
                                )
                                .foregroundStyle(item.component.color)
                                .cornerRadius(4)
                            }
                            .frame(height: 220)

                            VStack(spacing: 8) {
                                ForEach(byComponent.filter { $0.count > 0 }) { item in
                                    HStack {
                                        Circle()
                                            .fill(item.component.color)
                                            .frame(width: 10, height: 10)
                                        Text(item.component.rawValue)
                                            .font(.subheadline)
                                        Spacer()
                                        Text("\(item.count) razy · \(String(format: "%.2f", Double(item.volumeMl) / 1000)) l")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding(.top, 8)
                        }

                        section(title: "Częstotliwość") {
                            HStack(spacing: 12) {
                                StatCard(
                                    title: "Średni odstęp",
                                    value: averageInterval.map { "\(Int($0)) dni" } ?? "—",
                                    icon: "timer"
                                )
                                StatCard(
                                    title: "Lata dawstwa",
                                    value: "\(byYear.count)",
                                    icon: "calendar.badge.clock",
                                    tint: .purple
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Statystyki")
        }
    }

    @ViewBuilder
    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.bold())
            content()
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

#Preview {
    StatsView()
        .modelContainer(for: Donation.self, inMemory: true)
}
