import SwiftUI

struct MeshPreviewView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var scanName: String = ""
    @State private var scanDescription: String = ""
    @State private var showSnackbar: Bool = false
    var scan: ScanModel

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))

                if !scan.mesh.isEmpty {
                    Model3D(modelName: scan.mesh, isInteractionEnabled: true)
                        .cornerRadius(12)
                }
                
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

                TextField("Name:", text: $scanName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                TextField("Description: (optional)", text: $scanDescription)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                HStack(spacing: 12) {
                    Button(action: {
                        print("Share scan")
                    }) {
                        //TODO(Miky): Implement the Share method
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    }

                    Button(action: {
                        homeViewModel.saveScan(withName: scanName, description: scanDescription, from: scan)
                        showSnackbar = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showSnackbar = false
                            router.currentRoute = .home
                        }
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
        //TODO(Miky): Add error snackbar
        .overlay(
            Snackbar(isShowing: $showSnackbar, text: "Scan was successfully saved")
                .offset(y: showSnackbar ? 0 : 100)
                .animation(.spring(), value: showSnackbar)
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
            mesh: "test_obj.obj",
            description: "This is a sample scan for preview purposes"
        )

        MeshPreviewView(scan: sampleScan)
            .environmentObject(Router())
            .environmentObject(HomeViewModel())
    }
}
