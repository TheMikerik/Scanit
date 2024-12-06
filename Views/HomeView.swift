import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Favourite")
                        .font(.headline)
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(viewModel.models.filter { $0.favorite }) { scan in
                                ScanCard(scan: scan)
                                    .frame(width: 215, height: 150)
                                    .onTapGesture {
                                        router.currentRoute = .scanDetail(scan)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 150)

                    Text("All Scans")
                        .font(.headline)
                        .padding(.horizontal)
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.models) { scan in
                            ScanCard(scan: scan)
                                .frame(height: 180)
                                .onTapGesture {
                                    router.currentRoute = .scanDetail(scan)
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            VStack {
                Spacer()
                ScanButton {
                    router.currentRoute = .scanner
                }
            }
        }
        .navigationBarTitle("Scans", displayMode: .inline)
        .navigationBarItems(
            trailing: HStack {
                Button(action: {
                    router.currentRoute = .settings
                }) {
                    Image(systemName: "gear")
                }
            }
        )
    }
}

#Preview {
    HomeView()
        .environmentObject(Router())
        .environmentObject(HomeViewModel())
}
