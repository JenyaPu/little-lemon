import SwiftUI

struct Onboarding: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var currentPage: Int = 0 // Track the current page

    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $currentPage) {
                    OnboardingPage1()
                        .tag(0)
                    OnboardingPage2()
                        .tag(1)
                    OnboardingPage3(firstName: $firstName, lastName: $lastName, email: $email, isLoggedIn: $isLoggedIn)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

                // Next Button for navigating between pages
                Button(action: {
                    if currentPage < 2 {
                        currentPage += 1
                    } else {
                        // On the last page, validate and navigate
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
                }) {
                    Text(currentPage < 2 ? "Next" : "Register")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            .navigationTitle("Onboarding")
            .background(
                NavigationLink(destination: Home(firstName: firstName, lastName: lastName, email: email), isActive: $isLoggedIn) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }

    // Email validation function
    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}

// First onboarding page
struct OnboardingPage1: View {
    var body: some View {
        VStack {
            Text("Welcome to Little Lemon!")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Discover the best meals in Chicago.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// Second onboarding page
struct OnboardingPage2: View {
    var body: some View {
        VStack {
            Text("Explore Our Menu")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("We offer a wide variety of delicious dishes.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// Third onboarding page with user input
struct OnboardingPage3: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack {
            Text("Join Us!")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Sign up to experience our amazing service.")
                .font(.subheadline)
                .multilineTextAlignment(.center)

            // Text Fields for user input
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
            
        }
        .padding()
    }
}

#Preview {
    Onboarding()
}
