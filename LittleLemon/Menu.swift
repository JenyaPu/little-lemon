import SwiftUI

struct Menu: View {
    var body: some View {
        VStack {
            
            // App Title
            Text("Little Lemon Restaurant")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            // Location
            Text("Chicago")
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.top, 5)

            // Short Description
            Text("Enjoy fresh and delicious meals at the heart of the city.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 10)

            // Empty List for menu items
            List {
                // Menu items will be added later
            }
        }
    }
}

#Preview {
    Menu()
}
