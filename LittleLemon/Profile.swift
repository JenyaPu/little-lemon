import SwiftUI

struct ProfileView: View {
    @State private var firstName: String = UserDefaults.standard.string(forKey: "firstName") ?? ""
    @State private var lastName: String = UserDefaults.standard.string(forKey: "lastName") ?? ""
    @State private var email: String = UserDefaults.standard.string(forKey: "email") ?? ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Image("Profile") // Assuming the profile image is in assets
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .clipShape(Circle())

            Text("First Name: \(firstName)")
            Text("Last Name: \(lastName)")
            Text("Email: \(email)")

            Button("Log Out") {
                logOut()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .padding()
    }

    private func logOut() {
        // Clear user data from UserDefaults
        UserDefaults.standard.removeObject(forKey: "firstName")
        UserDefaults.standard.removeObject(forKey: "lastName")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding") // Optional: Clear onboarding flag
        
        // Navigate back to Onboarding
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    ProfileView()
}
