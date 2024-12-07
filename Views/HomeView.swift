import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: HomeViewModel
    
    @State private var selectedFilter: FilterOption = .newest

    var body: some View {
        ZStack {
            if viewModel.models.isEmpty {
                EmptyPageIndicator()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if !viewModel.models.filter({ $0.favorite }).isEmpty {
                            Text("Favourite")
                                .font(.headline)
                                .padding(.horizontal)
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 16) {
                                    ForEach(viewModel.models.filter { $0.favorite }) { scan in
                                        ScanCard(scan: scan, isInteractionEnabled: false)
                                            .frame(width: 215, height: 150)
                                            .onTapGesture {
                                                router.currentRoute = .scanDetail(scan)
                                            }
                                            .environmentObject(viewModel)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 150)
                        }
                        
                        HStack {
                            Text("All Scans")
                                .font(.headline)
                                .padding(.horizontal)
                            Spacer()
                            Picker("Filter", selection: $selectedFilter) {
                                Text("Newest").tag(FilterOption.newest)
                                Text("Oldest").tag(FilterOption.oldest)
                                Text("Largest").tag(FilterOption.largest)
                                Text("Smallest").tag(FilterOption.smallest)
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal)
                            .onChange(of: selectedFilter) {
                                viewModel.applyFilter(selectedFilter)
                            }
                        }
                        
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filteredModels) { scan in
                                ScanCard(scan: scan, isInteractionEnabled: false)
                                    .frame(height: 180)
                                    .onTapGesture {
                                        router.currentRoute = .scanDetail(scan)
                                    }
                                    .environmentObject(viewModel)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
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

enum FilterOption: String, CaseIterable {
    case newest = "Newest"
    case oldest = "Oldest"
    case largest = "Largest"
    case smallest = "Smallest"
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Router())
            .environmentObject(HomeViewModel())
    }
}