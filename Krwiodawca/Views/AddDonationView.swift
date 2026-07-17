import SwiftUI
import SwiftData

struct AddDonationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    private let editingDonation: Donation?

    @State private var date: Date
    @State private var component: BloodComponentType
    @State private var volumeMl: Int
    @State private var location: String
    @State private var notes: String

    init(editing donation: Donation? = nil) {
        self.editingDonation = donation
        _date = State(initialValue: donation?.date ?? .now)
        _component = State(initialValue: donation?.component ?? .wholeBlood)
        _volumeMl = State(initialValue: donation?.volumeMl ?? BloodComponentType.wholeBlood.defaultVolumeMl)
        _location = State(initialValue: donation?.location ?? "")
        _notes = State(initialValue: donation?.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Rodzaj donacji") {
                    Picker("Składnik krwi", selection: $component) {
                        ForEach(BloodComponentType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .onChange(of: component) { _, newValue in
                        if editingDonation == nil {
                            volumeMl = newValue.defaultVolumeMl
                        }
                    }

                    DatePicker("Data", selection: $date, in: ...Date.now, displayedComponents: .date)
                }

                Section("Szczegóły") {
                    Stepper(value: $volumeMl, in: 50...1000, step: 50) {
                        HStack {
                            Text("Objętość")
                            Spacer()
                            Text("\(volumeMl) ml")
                                .foregroundStyle(.secondary)
                        }
                    }
                    TextField("Miejsce (np. RCKiK Warszawa)", text: $location)
                    TextField("Notatki", text: $notes, axis: .vertical)
                }
            }
            .navigationTitle(editingDonation == nil ? "Nowa donacja" : "Edytuj donację")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Zapisz") { save() }
                }
            }
        }
    }

    private func save() {
        if let editingDonation {
            editingDonation.date = date
            editingDonation.component = component
            editingDonation.volumeMl = volumeMl
            editingDonation.location = location
            editingDonation.notes = notes
        } else {
            let donation = Donation(date: date, component: component, volumeMl: volumeMl, location: location, notes: notes)
            modelContext.insert(donation)
        }
        dismiss()
    }
}

#Preview {
    AddDonationView()
        .modelContainer(for: Donation.self, inMemory: true)
}
