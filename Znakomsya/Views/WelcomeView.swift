import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.red)
            Text("Добро пожаловать в Znakomsya!")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            Text("Начните свое путешествие по знакомствам прямо сейчас.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()

            NavigationLink(destination: RegistrationView()) {
                Text("Регистрация")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}

