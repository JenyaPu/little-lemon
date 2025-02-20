import SwiftUI

struct Onboarding: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var isLoggedIn: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                // Hidden NavigationLink
                NavigationLink(destination: Home(firstName: firstName, lastName: lastName, email: email), isActive: $isLoggedIn) {
                    EmptyView()
                }


                HeroSection()
                
                // Text Fields
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()

                // Register Button
                Button("Register") {
                    if !firstName.isEmpty, !lastName.isEmpty, isValidEmail(email) {
                        // Store data in UserDefaults
                        UserDefaults.standard.set(firstName, forKey: "firstName")
                        UserDefaults.standard.set(lastName, forKey: "lastName")
                        UserDefaults.standard.set(email, forKey: "email")

                        isLoggedIn = true // Navigate to Home
                    } else {
                        print("Error: Please enter valid information.")
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .padding()
        }
    }

    // Email validation function
    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    Onboarding()
}
