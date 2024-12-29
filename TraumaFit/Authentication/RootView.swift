import SwiftUI

struct RootView: View {
    
    @State private var showSignIn: Bool = false
    @State private var isAuthenticated: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                if isAuthenticated {
                    Homepage(showSignIn: $showSignIn)
                } else {
                    SettingsView(showSignIn: $showSignIn)
                }
            }
        }
        .onAppear {
            checkAuthStatus()
        }
        .fullScreenCover(isPresented: $showSignIn) {
            NavigationStack {
                AuthView(showSignIn: $showSignIn)
                    .onDisappear {
                        checkAuthStatus()
                    }
            }
        }
    }
    
    private func checkAuthStatus() {
        
        if let _ = try? Authmanager.shared.getAuthUser() {
            isAuthenticated = true
            showSignIn = false
        } else {
            isAuthenticated = false
            showSignIn = true
        }
    }
}

#Preview {
    RootView()
}
