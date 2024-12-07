import Foundation

class HomeViewModel: ObservableObject {
    @Published var models: [ScanModel] = MockData.scans
    @Published var filteredModels: [ScanModel] = []

    init() {
        applyFilter(.newest)
    }

    //Settings Funcs
    func deleteAllScans() {
        models.removeAll()
        filteredModels.removeAll()
        print("All scans deleted.")
    }

    func loadMockScans() {
        models = MockData.scans
        applyFilter(.newest)
        print("Mock scans loaded.")
    }

    //Home Funcs
    func toggleFavorite(for scan: ScanModel) {
        if let index = models.firstIndex(where: { $0.id == scan.id }) {
            models[index].favorite.toggle()
            applyFilter(.newest)
        }
    }
    
    func applyFilter(_ filter: FilterOption) {
        switch filter {
        case .newest:
            filteredModels = models.sorted { $0.date > $1.date }
        case .oldest:
            filteredModels = models.sorted { $0.date < $1.date }
        case .largest:
            filteredModels = models.sorted { $0.size > $1.size }
        case .smallest:
            filteredModels = models.sorted { $0.size < $1.size }
        }
    }

    //MeshPreview Funcs
    func saveScan(withName name: String, description: String?, from scan: ScanModel) {
        let newScan = ScanModel(
            name: name.isEmpty ? scan.name : name,
            date: Date(),
            favorite: scan.favorite,
            size: scan.size,
            mesh: scan.mesh,
            description: description ?? scan.description
        )
        models.append(newScan)
        applyFilter(.newest)
        print("Scan saved: \(newScan.name)")
    }
}