import SwiftUI

enum Route {
    case home
    case scanner
    case meshPreview
    case settings
    case scanDetail(ScanModel)
}

class Router: ObservableObject {
    @Published var currentRoute: Route = .home
}
