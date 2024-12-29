import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    func logOut() throws {
        try Authmanager.shared.signOut()
    }
    
    func resetPassword(email: String) async throws {
        try await Authmanager.shared.resetPassword(email: email)
    }
    
    func updateEmail(email: String) async throws {
        try await Authmanager.shared.updateEmail(email: email)
    }
    
    func updatePassword(password: String) async throws {
        try await Authmanager.shared.updatePassword(password: password)
    }
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignIn: Bool
    @State private var navigateToWelcome: Bool = false 
    
    @State private var resetEmail: String = ""
    @State private var newEmail: String = ""
    @State private var newPassword: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    
                    Button("Log out") {
                        Task {
                            do {
                                try viewModel.logOut()
                                navigateToWelcome = true
                            } catch {
                                print("Error logging out: \(error)")
                            }
                        }
                    }
                    
                    Section(header: Text("RESET").font(.headline)) {
                        
                        TextField("Enter email to reset password", text: $resetEmail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Reset Password") {
                            Task {
                                do {
                                    try await viewModel.resetPassword(email: resetEmail)
                                    resetEmail = ""
                                    showAlert = true
                                } catch {
                                    print("Error resetting password: \(error)")
                                }
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Success"),
                                message: Text("Check your email for the password reset instructions."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                        
                        
                        TextField("Enter new email", text: $newEmail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Update Email") {
                            Task {
                                do {
                                    try await viewModel.updateEmail(email: newEmail)
                                    newEmail = ""
                                    showAlert = true
                                } catch {
                                    print("Error updating email: \(error)")
                                }
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Success"),
                                message: Text("Email Updated!"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                        
                        
                        SecureField("Enter new password", text: $newPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Update Password") {
                            Task {
                                do {
                                    try await viewModel.updatePassword(password: newPassword)
                                    newPassword = ""
                                    showAlert = true
                                } catch {
                                    print("Error updating password: \(error)")
                                }
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Success"),
                                message: Text("Password Updated!"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationDestination(isPresented: $navigateToWelcome) {
                WelcomeView() 
            }
        }
    }
}


#Preview {
    SettingsView(showSignIn: .constant(false))
}
