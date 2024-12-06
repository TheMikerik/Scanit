import SwiftUI

struct AppRouter: View {
    @EnvironmentObject var router: Router
    @StateObject var homeViewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            switch router.currentRoute {

            case .home:
                HomeView()
                    .environmentObject(homeViewModel)
                    .environmentObject(router)

            case .scanner:
                ScannerView()
                    .environmentObject(router)

            case .meshPreview:
                if let firstScan = MockData.scans.first {
                    MeshPreviewView(scan: firstScan)
                        .environmentObject(router)
                } else {
                    Text("No scan available")
                }

            case .settings:
                SettingsView()
                    .environmentObject(router)
                    .environmentObject(homeViewModel) 

            case .scanDetail(let scan):
                ScanDetailView(scan: scan)
                    .environmentObject(router)

            }
        }
    }
}

#Preview {
    AppRouter()
        .environmentObject(Router())
}
