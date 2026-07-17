import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Donation.date, order: .reverse) private var donations: [Donation]
    @State private var showingAddSheet = false
    @State private var editingDonation: Donation?

    var body: some View {
        NavigationStack {
            Group {
                if donations.isEmpty {
                    ContentUnavailableView(
                        "Brak donacji",
                        systemImage: "list.bullet.rectangle",
                        description: Text("Dodaj swoją pierwszą donację krwi.")
                    )
                } else {
                    List {
                        ForEach(donations) { donation in
                            Button {
                                editingDonation = donation
                            } label: {
                                donationRow(donation)
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: deleteDonations)
                    }
                }
            }
            .navigationTitle("Historia")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddDonationView()
            }
            .sheet(item: $editingDonation) { donation in
                AddDonationView(editing: donation)
            }
        }
    }

    private func donationRow(_ donation: Donation) -> some View {
        HStack(spacing: 12) {
            Image(systemName: donation.component.icon)
                .foregroundStyle(donation.component.color)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(donation.component.rawValue)
                    .font(.headline)
                Text(donation.date.formatted(date: .long, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if !donation.location.isEmpty {
                    Text(donation.location)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()

            Text("\(donation.volumeMl) ml")
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private func deleteDonations(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(donations[index])
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: Donation.self, inMemory: true)
}
