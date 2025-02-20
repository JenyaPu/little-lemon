import SwiftUI

struct Home: View {
    // Step 1: Initialize Core Data
    let persistence = PersistenceController.shared

    // Properties to hold user information
    var firstName: String
    var lastName: String
    var email: String

    var body: some View {
        TabView {
            Menu()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    Home(firstName: "John", lastName: "Doe", email: "john.doe@example.com")
}
