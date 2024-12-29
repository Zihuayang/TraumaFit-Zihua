import SwiftUI

@MainActor
final class SigninEmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    

    var canSignIn: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    func signUp() async throws {
        guard canSignIn else {
            print("No email or password found")
            return
        }
        
        try await Authmanager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        guard canSignIn else {
            print("No email or password found")
            return
        }
        
        try await Authmanager.shared.signInUser(email: email, password: password)
    }
}

struct SigninEmail: View {
    
    @StateObject var viewModel = SigninEmailViewModel()
    @Binding var showSignIn: Bool
    @State private var navigateToHomepage: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
               
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                
                Button {
                    Task {
                        do {
                            
                            try await viewModel.signUp()
                            navigateToHomepage = true
                            return
                        } catch {
                            print("Sign up failed: \(error)")
                        }
                        
                        do {
                            
                            try await viewModel.signIn()
                            navigateToHomepage = true
                            return
                        } catch {
                            print("Sign in failed: \(error)")
                        }
                    }
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.canSignIn ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(!viewModel.canSignIn) 
                
                Spacer()
            }
            .navigationTitle("Sign In with Email")
            .navigationDestination(isPresented: $navigateToHomepage) {
                Homepage(showSignIn: $showSignIn)
            }
        }
    }
}

#Preview {
    SigninEmail(showSignIn: .constant(false))
}
