import SwiftUI

struct RCKiKListView: View {
    @Environment(\.openURL) private var openURL
    @State private var searchText = ""

    private var filteredCenters: [BloodCenter] {
        guard !searchText.isEmpty else { return BloodCenters.all }
        return BloodCenters.all.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.address.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredCenters) { center in
                VStack(alignment: .leading, spacing: 10) {
                    Text(center.name)
                        .font(.headline)
                    Text(center.address)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 10) {
                        Button {
                            navigate(to: center)
                        } label: {
                            Label("Nawiguj", systemImage: "location.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .tint(.red)

                        if let websiteURL = center.websiteURL {
                            Button {
                                openURL(websiteURL)
                            } label: {
                                Label("Strona internetowa", systemImage: "safari.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .tint(.blue)
                        }
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
                .padding(.vertical, 6)
            }
            .listStyle(.plain)
            .searchable(text: $searchText, prompt: "Szukaj miasta")
            .navigationTitle("RCKiK")
        }
    }

    private func navigate(to center: BloodCenter) {
        let query = "\(center.name), \(center.address), Polska"
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://maps.apple.com/?daddr=\(encoded)") else { return }
        openURL(url)
    }
}

#Preview {
    RCKiKListView()
}
