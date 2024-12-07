import SwiftUI

struct Snackbar: View {
    @Binding var isShowing: Bool
    var text: String

    var body: some View {
        if isShowing {
            VStack {
                Spacer()
                Text(text)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding()
            }
            .transition(.move(edge: .bottom))
            .zIndex(1.0)
        }
    }
}

struct Snackbar_Previews: PreviewProvider {
    @State static var isShowing = true

    static var previews: some View {
        Snackbar(isShowing: $isShowing, text: "Snackbar Message")
    }
}