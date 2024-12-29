import SwiftUI

struct AuthView: View {
    @Binding var showSignIn: Bool

    var body: some View {
        VStack {
            Spacer()

            NavigationLink {
                SigninEmail(showSignIn: $showSignIn)
            } label: {
                Text("Sign in with Email")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            Spacer() 
        }
        .navigationTitle("Sign In")
    }
}

#Preview {
    AuthView(showSignIn: .constant(false))
}
