import SwiftUI

struct WelcomeView: View {
    @State private var isRegistrationPresented = false
    
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

            Button(action: {
                isRegistrationPresented.toggle()
            }) {
                Text("Регистрация")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .fullScreenCover(isPresented: $isRegistrationPresented) {
                RegistrationView().environmentObject(ModelData())
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}


