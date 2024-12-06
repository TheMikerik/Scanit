import Foundation

struct MockData {
    static let scans: [ScanModel] = [
        ScanModel(
            name: "Living Room",
            date: Date(),
            favorite: true,
            size: 12.5,
            mesh: "test_obj.obj",
            description: "3D ScanModel of the living room."
        ),
        ScanModel(
            name: "Office Desk",
            date: Date(),
            favorite: false,
            size: 8.1,
            mesh: "test_obj2.obj",
            description: nil
        ),
        ScanModel(
            name: "Backyard",
            date: Date(),
            favorite: true,
            size: 25.3,
            mesh: "test_obj2.obj",
            description: "Backyard ScanModel for gardening plans."
        ),
        ScanModel(
            name: "Car Interior",
            date: Date(),
            favorite: false,
            size: 15.0,
            mesh: "test_obj2.obj",
            description: nil
        ),
        ScanModel(
            name: "Bedroom",
            date: Date(),
            favorite: true,
            size: 10.2,
            mesh: "test_obj2.obj",
            description: nil
        ),
        ScanModel(
            name: "Coffee Table",
            date: Date(),
            favorite: false,
            size: 5.7,
            mesh: "test_obj2.obj",
            description: "Small ScanModel of the coffee table."
        ),
        ScanModel(
            name: "Kitchen",
            date: Date(),
            favorite: true,
            size: 30.0,
            mesh: "test_obj2.obj",
            description: "Complete ScanModel of the kitchen area."
        ),
        ScanModel(
            name: "Chair",
            date: Date(),
            favorite: false,
            size: 3.5,
            mesh: "test_obj2.obj",
            description: "A small ScanModel of a wooden chair."
        ),
        ScanModel(
            name: "Shelf",
            date: Date(),
            favorite: false,
            size: 6.2,
            mesh: "test_obj2.obj",
            description: nil
        ),
        ScanModel(
            name: "Garage",
            date: Date(),
            favorite: true,
            size: 20.8,
            mesh: "test_obj2.obj",
            description: "Full ScanModel of the garage space."
        )
    ]
}
