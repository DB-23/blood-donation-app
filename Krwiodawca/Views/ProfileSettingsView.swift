import SwiftUI

struct ProfileSettingsView: View {
    @EnvironmentObject private var donorSettings: DonorSettings
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Twoje dane") {
                    TextField("Imię", text: $donorSettings.name)
                    Picker("Płeć", selection: $donorSettings.sex) {
                        ForEach(DonorSex.allCases, id: \.self) { sex in
                            Text(sex.rawValue).tag(sex)
                        }
                    }
                    Picker("Grupa krwi", selection: $donorSettings.bloodType) {
                        ForEach(DonorSettings.bloodTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                }

                Section {
                    Text("Płeć wpływa na roczne limity donacji krwi pełnej oraz progi odznak \"Zasłużony Honorowy Dawca Krwi\", zgodnie z wytycznymi polskich RCKiK.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Profil")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Gotowe") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ProfileSettingsView()
        .environmentObject(DonorSettings())
}
