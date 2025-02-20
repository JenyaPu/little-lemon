import SwiftUI

struct ProfileView: View {
    var firstName: String
    var lastName: String
    var email: String

    var body: some View {
        VStack {
            Image("Profile") // Replace with your asset name
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding()

            Text("\(firstName) \(lastName)")
                .font(.title)
                .fontWeight(.bold)

            Text(email)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 2)

            Spacer()
        }
        .padding()
    }
}
