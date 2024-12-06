import Foundation

struct ScanModel: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let favorite: Bool
    let size: Double
    let mesh: String
    let description: String?
}
