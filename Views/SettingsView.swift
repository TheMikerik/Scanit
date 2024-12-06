import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var router: Router
    
    @State private var selectedTheme = "Light"
    @State private var modelFormat = "OBJ"
    @State private var enableTextures = true

    var body: some View {
        Form {
            Section(header: Text("General")) {
                Picker("Theme", selection: $selectedTheme) {
                    Text("Light").tag("Light")
                    Text("Dark").tag("Dark")
                    Text("System").tag("System")
                }
            }
            
            Section(header: Text("Models")) {
                Toggle(isOn: $enableTextures) {
                    Text("Enable Textures")
                }
                
                Picker("Model Format", selection: $modelFormat) {
                    Text("OBJ").tag("OBJ")
                    Text("STL").tag("STL")
                    Text("PLY").tag("PLY")
                }
            }
            
            Section(header: Text("Scans")) {
                Text("Delete All Scans")
            }

            Section(header: Text("Account")) {
                Button(action: {
                    print("Log out")
                }) {
                    Text("Log Out")
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    print("Delete account")
                }) {
                    Text("Delete Account")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationBarTitle("Settings", displayMode: .inline)
        .navigationBarItems(
            leading: Button(action: {
                router.currentRoute = .home
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
        )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Router())
    }
}
