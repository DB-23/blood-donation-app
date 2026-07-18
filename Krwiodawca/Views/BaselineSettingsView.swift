import SwiftUI

struct BaselineSettingsView: View {
    @EnvironmentObject private var donorSettings: DonorSettings

    var body: some View {
        Form {
            Section {
                Text("Jeśli oddawałeś/aś już krew przed zainstalowaniem aplikacji, wpisz tu dotychczasowy dorobek z legitymacji dawcy — nie musisz dodawać każdej dawnej donacji osobno. Nowe donacje rejestruj normalnie w zakładce Historia.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            ForEach(BloodComponentType.allCases) { component in
                Section(component.rawValue) {
                    BaselineComponentEditor(donorSettings: donorSettings, component: component)
                }
            }
        }
        .navigationTitle("Stan początkowy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct BaselineComponentEditor: View {
    @ObservedObject var donorSettings: DonorSettings
    let component: BloodComponentType

    @State private var count: Int
    @State private var liters: Double
    @State private var hasLastDonationDate: Bool
    @State private var lastDonationDate: Date

    init(donorSettings: DonorSettings, component: BloodComponentType) {
        self.donorSettings = donorSettings
        self.component = component
        let baseline = donorSettings.baseline(for: component)
        _count = State(initialValue: baseline.count)
        _liters = State(initialValue: Double(baseline.volumeMl) / 1000)
        _hasLastDonationDate = State(initialValue: baseline.lastDonationDate != nil)
        _lastDonationDate = State(initialValue: baseline.lastDonationDate ?? .now)
    }

    var body: some View {
        Stepper(value: $count, in: 0...300) {
            HStack {
                Text("Liczba donacji")
                Spacer()
                Text("\(count)")
                    .foregroundStyle(.secondary)
            }
        }
        .onChange(of: count) { _, _ in save() }

        HStack {
            Text("Łączna objętość")
            Spacer()
            TextField("0", value: $liters, format: .number.precision(.fractionLength(0...2)))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 70)
                .onChange(of: liters) { _, _ in save() }
            Text("l")
                .foregroundStyle(.secondary)
        }

        Toggle("Znam datę ostatniej donacji", isOn: $hasLastDonationDate)
            .onChange(of: hasLastDonationDate) { _, _ in save() }

        if hasLastDonationDate {
            DatePicker("Data ostatniej donacji", selection: $lastDonationDate, in: ...Date.now, displayedComponents: .date)
                .onChange(of: lastDonationDate) { _, _ in save() }
        }
    }

    private func save() {
        donorSettings.updateBaseline(for: component) { baseline in
            baseline.count = count
            baseline.volumeMl = Int((liters * 1000).rounded())
            baseline.lastDonationDate = hasLastDonationDate ? lastDonationDate : nil
        }
    }
}

#Preview {
    NavigationStack {
        BaselineSettingsView()
            .environmentObject(DonorSettings())
    }
}
