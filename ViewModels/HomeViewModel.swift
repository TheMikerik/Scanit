import Foundation

class HomeViewModel: ObservableObject {
    @Published var models: [ScanModel] = MockData.scans
}
