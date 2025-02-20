import SwiftUI

// Step 1: Define global keys for UserDefaults
let kFirstName = "first_name_key"
let kLastName = "last_name_key"
let kEmail = "email_key"

struct Onboarding: View {
    // Step 2: Declare state variables
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""

    var body: some View {
        VStack {
            // Step 3: Add text fields
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

            // Step 4: Add a Register button
            Button("Register") {
                // Step 5: Validate inputs before storing
                if !firstName.isEmpty, !lastName.isEmpty, isValidEmail(email) {
                    // Step 6: Save data to UserDefaults
                    UserDefaults.standard.set(firstName, forKey: kFirstName)
                    UserDefaults.standard.set(lastName, forKey: kLastName)
                    UserDefaults.standard.set(email, forKey: kEmail)

                    print("User registered successfully!")
                } else {
                    print("Error: Please enter valid information.")
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .padding()
    }

    // Step 7: Email validation function
    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    Onboarding()
}
