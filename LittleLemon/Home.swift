import SwiftUI

struct Home: View {
    // Step 1: Initialize Core Data
    let persistence = PersistenceController.shared

    var body: some View {
        TabView {
            Menu()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
        }
    }
}

#Preview {
    Home()
}
