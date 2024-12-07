import SwiftUI

struct ScanDetailView: View {
    let scan: ScanModel
    @EnvironmentObject var router: Router

    //TODO(Miky): Add edit so the name, description can be edited
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .edgesIgnoringSafeArea(.bottom)
                        .frame(width: geometry.size.width, height: geometry.size.height)

                    if !scan.mesh.isEmpty {
                        Model3D(modelName: scan.mesh, isInteractionEnabled: true)
                            .cornerRadius(12)
                    }

                    VStack {
                        Text(scan.name)
                            .font(.largeTitle)
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text("\(scan.date, format: .dateTime.year().month().day().hour().minute()) · \(scan.size, specifier: "%.2f") MB")
                            .font(.callout)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .center)


                        Spacer()

                        VStack{
                            if let description = scan.description {
                                HStack {
                                    Text(description)
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    print("Share scan")
                                }) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                        Text("Share")
                                    }
                                    .font(.system(size: 18))
                                    .padding()
                                    .frame(minWidth: 200)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                                    .foregroundColor(.white)
                                    .padding()
                                }
                                
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Gallery", displayMode: .inline)
        .navigationBarItems(
            leading: Button(action: {
                router.currentRoute = .home
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            },
            trailing: Button(action: {
                print("Remove scan")
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        )
    }
}

struct ScanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleScan = ScanModel(
            name: "Sample Scan",
            date: Date(),
            favorite: true,
            size: 123.45,
            mesh: "3D Model Placeholder",
            description: "This is a sample scan for preview purposes"
        )

        ScanDetailView(scan: sampleScan)
            .environmentObject(Router())
    }
}
