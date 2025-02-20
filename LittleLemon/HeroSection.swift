import SwiftUI

struct HeroSection: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Little Lemon Restaurant")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text("Chicago")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
                
                Text("Enjoy fresh and delicious meals at the heart of the city.")
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            }
            .padding()

            Image("Hero image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding()
        }
        .background(Color.white)
    }
}

struct HeroSection_Previews: PreviewProvider {
    static var previews: some View {
        HeroSection()
    }
}
