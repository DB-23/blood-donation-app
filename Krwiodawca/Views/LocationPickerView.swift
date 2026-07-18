import SwiftUI

struct LocationPickerView: View {
    @Binding var selection: String
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var showingManualEntry = false
    @State private var manualLocation = ""

    private var filteredCenters: [BloodCenter] {
        guard !searchText.isEmpty else { return BloodCenters.all }
        return BloodCenters.all.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.address.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        manualLocation = BloodCenters.all.contains(where: { $0.name == selection }) ? "" : selection
                        showingManualEntry = true
                    } label: {
                        Label("Inny punkt (wpisz ręcznie)", systemImage: "square.and.pencil")
                    }
                }

                Section("Regionalne Centra Krwiodawstwa i Krwiolecznictwa") {
                    ForEach(filteredCenters) { center in
                        Button {
                            selection = center.name
                            dismiss()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(center.name)
                                        .foregroundStyle(.primary)
                                    Text(center.address)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                if selection == center.name {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Szukaj miasta")
            .navigationTitle("Miejsce donacji")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") { dismiss() }
                }
            }
            .alert("Inny punkt", isPresented: $showingManualEntry) {
                TextField("Nazwa punktu poboru krwi", text: $manualLocation)
                Button("Anuluj", role: .cancel) { }
                Button("Zapisz") {
                    let trimmed = manualLocation.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    selection = trimmed
                    dismiss()
                }
            } message: {
                Text("Np. mobilny punkt krwiodawstwa lub oddział terenowy.")
            }
        }
    }
}

#Preview {
    LocationPickerView(selection: .constant(""))
}
