import SwiftUI

struct ScanCard: View {
    let scan: ScanModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
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
        let sampleScan = ScanModel(
            name: "Tst",
            date: Date(),
            favorite: true,
            size: 123.45,
            mesh: "",
            description: ""
        )
        ScanCard(scan: sampleScan)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
