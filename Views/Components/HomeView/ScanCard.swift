import SwiftUI

struct ScanCard: View {
    let scan: ScanModel
    let isInteractionEnabled: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))

            if !scan.mesh.isEmpty {
                Model3D(modelName: scan.mesh, isInteractionEnabled: isInteractionEnabled)
                    .cornerRadius(12)
            }

            VStack {
                HStack {
                    Text(scan.name)
                        .font(.headline)
                    Spacer()
                    Image(systemName: scan.favorite ? "star.fill" : "star")
                        .foregroundColor(scan.favorite ? .yellow : .gray)
                }
                Spacer()
                HStack {
                    Text(scan.date, format: .dateTime.year().month().day())
                        .font(.subheadline)
                    Spacer()
                    Text("\(scan.size, specifier: "%.2f") MB")
                        .font(.subheadline)
                }
            }
            .padding()
        }
    }
}

struct ScanCard_Previews: PreviewProvider {
    static var previews: some View {
        let sampleScanWithModel = ScanModel(
            name: "Test Model",
            date: Date(),
            favorite: true,
            size: 2.3,
            mesh: "test_obj.obj",
            description: "A test 3D model."
        )
        let sampleScanWithoutModel = ScanModel(
            name: "Tst",
            date: Date(),
            favorite: true,
            size: 123.45,
            mesh: "",
            description: ""
        )
        VStack {
            ScanCard(scan: sampleScanWithModel, isInteractionEnabled: false)
                .padding()
                .previewLayout(.sizeThatFits)

            ScanCard(scan: sampleScanWithoutModel, isInteractionEnabled: false)
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}