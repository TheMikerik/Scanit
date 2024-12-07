import SwiftUI

struct ScannerView: View {
    @EnvironmentObject var router: Router
    @State private var isProcessing: Bool = false

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    CameraView()
                        .edgesIgnoringSafeArea(.bottom)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 15, height: 15)
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    
                    VStack {
                        Spacer()
                        
                        Button(action: {
                            print("Start scanning")
                            isProcessing = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isProcessing = false
                                router.currentRoute = .meshPreview
                            }
                        }) {
                            Text("Start Scanning")
                                .font(.headline)
                                .padding()
                                .frame(minWidth: 200)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
            
            if isProcessing {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    ProgressView("Processing Scan...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Please wait while the scan is processed.")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.black.opacity(0.7)))
                .shadow(radius: 10)
            }
        }
        .navigationBarTitle("Scanner", displayMode: .inline)
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

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
            .environmentObject(Router())
    }
}
