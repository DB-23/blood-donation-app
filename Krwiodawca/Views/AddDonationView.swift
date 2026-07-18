import SwiftUI
import SwiftData

struct AddDonationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Donation.date) private var allDonations: [Donation]

    private let editingDonation: Donation?

    @State private var date: Date
    @State private var component: BloodComponentType
    @State private var volumeMl: Int
    @State private var location: String
    @State private var notes: String
    @State private var showingLocationPicker = false
    @State private var showingIntervalConfirmation = false

    /// Donacje tego samego składnika krwi co formularz, z pominięciem edytowanego rekordu.
    private var otherDonationsOfSameComponent: [Donation] {
        allDonations.filter { $0.component == component && $0.id != editingDonation?.id }
    }

    /// Ostrzeżenia o zbyt krótkim odstępie od sąsiadujących w czasie donacji tego samego składnika.
    private var intervalWarnings: [String] {
        let interval = EligibilityCalculator.minimumIntervalDays(for: component)
        let calendar = Calendar.current
        var warnings: [String] = []

        if let previous = otherDonationsOfSameComponent.filter({ $0.date < date }).max(by: { $0.date < $1.date }) {
            let days = calendar.dateComponents([.day], from: previous.date, to: date).day ?? 0
            if days < interval {
                warnings.append("Od poprzedniej donacji (\(previous.date.formatted(date: .abbreviated, time: .omitted))) minęło tylko \(days) z wymaganych \(interval) dni.")
            }
        }

        if let next = otherDonationsOfSameComponent.filter({ $0.date > date }).min(by: { $0.date < $1.date }) {
            let days = calendar.dateComponents([.day], from: date, to: next.date).day ?? 0
            if days < interval {
                warnings.append("Do kolejnej donacji (\(next.date.formatted(date: .abbreviated, time: .omitted))) jest tylko \(days) z wymaganych \(interval) dni.")
            }
        }

        return warnings
    }

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

                if !intervalWarnings.isEmpty {
                    Section {
                        ForEach(intervalWarnings, id: \.self) { warning in
                            Label(warning, systemImage: "exclamationmark.triangle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.orange)
                        }
                    } footer: {
                        Text("Minimalny odstęp dla \(component.rawValue.lowercased()) wynosi \(EligibilityCalculator.minimumIntervalDays(for: component)) dni. Sprawdź datę — jeśli jest prawidłowa, i tak będziesz mógł/mogła zapisać donację.")
                    }
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
                    Button {
                        showingLocationPicker = true
                    } label: {
                        HStack {
                            Text("Miejsce")
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(location.isEmpty ? "Wybierz" : location)
                                .foregroundStyle(location.isEmpty ? .secondary : .primary)
                                .multilineTextAlignment(.trailing)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }

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
            .sheet(isPresented: $showingLocationPicker) {
                LocationPickerView(selection: $location)
            }
            .confirmationDialog(
                "Zbyt krótki odstęp między donacjami",
                isPresented: $showingIntervalConfirmation,
                titleVisibility: .visible
            ) {
                Button("Zapisz mimo to", role: .destructive) { performSave() }
                Button("Anuluj", role: .cancel) { }
            } message: {
                Text(intervalWarnings.joined(separator: "\n"))
            }
        }
    }

    private func save() {
        guard intervalWarnings.isEmpty else {
            showingIntervalConfirmation = true
            return
        }
        performSave()
    }

    private func performSave() {
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
