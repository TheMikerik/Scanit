import SwiftUI

struct MeshPreviewView: View {
    @EnvironmentObject var router: Router
    var scan: ScanModel

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                VStack {
                    Spacer()
                    HStack {
                        Text(scan.date, format: .dateTime.year().month().day().hour().minute())
                            .font(.subheadline)
                        Spacer()
                        Text("\(scan.size, specifier: "%.2f") MB")
                            .font(.subheadline)
                    }
                }
                .padding()
            }
            .padding()

            Spacer()

            VStack(spacing: 12) {
                Text("Save Scan")
                    .font(.headline)

                TextField("Name:", text: .constant(""))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                TextField("Description: (optional)", text: .constant(""))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                // Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        // Share action
                        print("Share scan")
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    }

                    Button(action: {
                        print("Save scan")
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Save")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                        .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle("Scan Preview", displayMode: .inline)
        .navigationBarItems(
            leading: Button(action: {
                router.currentRoute = .home
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
        )
    }
}

struct MeshPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleScan = ScanModel(
            name: "Sample Scan",
            date: Date(),
            favorite: true,
            size: 123.45,
            mesh: "3D Model Placeholder",
            description: "This is a sample scan for preview purposes"
        )

        MeshPreviewView(scan: sampleScan)
            .environmentObject(Router())
    }
}
