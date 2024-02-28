import SwiftUI

struct WelcomeView: View {
    @State private var isRegistrationPresented = false
    @EnvironmentObject var modelData: ModelData
    
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

            TextField("Номер телефона", text: $modelData.registrationData.username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.phonePad)

            SecureField("Пароль", text: $modelData.registrationData.password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            HStack {
                Button(action: {
                    // Добавьте код для обработки входа
                }) {
                    Text("Войти")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }
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
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
        .environmentObject(ModelData())
}

