import Foundation

class HomeViewModel: ObservableObject {
    @Published var models: [ScanModel] = MockData.scans

    func deleteAllScans() {
        models.removeAll()
        print("All scans deleted.")
    }

    func loadMockScans() {
        models = MockData.scans
        print("Mock scans loaded.")
    }

    func toggleFavorite(for scan: ScanModel) {
        if let index = models.firstIndex(where: { $0.id == scan.id }) {
            models[index].favorite.toggle()
        }
    }
}