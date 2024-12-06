import SwiftUI

struct EmptyPageIndicator: View {
    var body: some View {
        VStack {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No scans available")
                .font(.headline)
                .foregroundColor(.gray)
            Text("Start by tapping the scan button below.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

struct EmptyPageIndicator_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPageIndicator()
    }
}