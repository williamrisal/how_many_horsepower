import SwiftUI

struct SettingsView: View {
    @AppStorage("useMPH") private var useMPH = true
    @AppStorage("useKW") private var useKW = true

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(LocalizedStringKey("settings_section_units")).foregroundColor(.white)) {
                    Toggle(LocalizedStringKey("settings_speed_toggle"), isOn: $useMPH)
                        .tint(Color(hex: "FF9C07"))
                    Toggle(LocalizedStringKey("settings_power_toggle"), isOn: $useKW)
                        .tint(Color(hex: "FF9C07"))
                }

                Section(header: Text(LocalizedStringKey("settings_section_conversions")).foregroundColor(.white)) {
                    HStack {
                        Text(LocalizedStringKey("settings_speed_preview"))
                        Spacer()
                        Text(useMPH ? LocalizedStringKey("settings_speed_value_kmh") : LocalizedStringKey("settings_speed_value_mph"))
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text(LocalizedStringKey("settings_power_preview"))
                        Spacer()
                        Text(useKW ? LocalizedStringKey("settings_power_value_hp") : LocalizedStringKey("settings_power_value_kw"))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .background(Color(hex: "1E1E1E"))
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(LocalizedStringKey("settings_title"))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
        .background(Color(hex: "1E1E1E"))
    }
}

#Preview {
    SettingsView()
}
