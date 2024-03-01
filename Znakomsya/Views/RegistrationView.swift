import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var isImagePickerPresented = false
    @State private var isRegistrationCancelled = false
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var phoneNumber = ""
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    let cities = Cities.all
    
    private func isValidNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^\\+7\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: phoneNumber)
    }
    
    private func isValidAge(_ birthDate: Date) -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        if let age = calendar.dateComponents([.year], from: birthDate, to: currentDate).year {
            return age >= 16
        }
        return false
    }
    
    private func isValidPassword() -> Bool {
        return password == confirmPassword && !password.isEmpty
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text("Регистрация")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .navigationBarItems(leading: Button(action: {
                            isRegistrationCancelled = true
                        }) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        })
                    
                    Form {
                        Section {
                            TextField("Имя", text: $modelData.registrationData.name)
                                .autocapitalization(.words)
                            DatePicker("Дата рождения", selection: $modelData.registrationData.birthDate, in: ...Date(), displayedComponents: .date)
                            Picker("Пол", selection: $modelData.registrationData.gender) {
                                Text("Мужской").tag("М")
                                Text("Женский").tag("Ж")
                            }
                            Picker("Город", selection: $modelData.registrationData.city) {
                                ForEach(cities, id: \.self) { city in
                                    Text(city)
                                }
                            }
                            TextField("Номер телефона", text: $phoneNumber)
                                .keyboardType(.phonePad)
                        }
                        
                        Section {
                            SecureField("Пароль", text: $password)
                            SecureField("Подтвердите пароль", text: $confirmPassword)
                        }
                        
                        Section {
                            HStack {
                                Text("Фото")
                                    .font(.headline)
                                    .padding(.vertical, 5)
                                Spacer()
                                if let photo = modelData.registrationData.photo {
                                    photo
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "camera")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.blue)
                                }
                            }
                            .onTapGesture {
                                isImagePickerPresented.toggle()
                            }
                        }
                        
                        Section {
                            Button("Сохранить") {
                                guard isValidAge(modelData.registrationData.birthDate) else {
                                    showErrorAlert = true
                                    errorMessage = "Пользователь должен быть не младше 14 лет"
                                    return
                                }
                                
                                guard isValidNumber(phoneNumber) else {
                                    showErrorAlert = true
                                    errorMessage = "Неверный номер телефона"
                                    return
                                }
                                
                                modelData.registrationData.username = phoneNumber
                                
                                guard isValidPassword() else {
                                    showErrorAlert = true
                                    errorMessage = "Пароли не совпадают"
                                    return
                                }
                                
                                modelData.registrationData.password = password
                                
                                guard !modelData.registrationData.name.isEmpty,
                                      !modelData.registrationData.username.isEmpty,
                                      !modelData.registrationData.password.isEmpty,
                                      modelData.registrationData.photo != nil
                                else {
                                    showErrorAlert = true
                                    errorMessage = "Все поля должны быть заполнены"
                                    return
                                }
                                
                                print("Данные: \(modelData.registrationData)")
                                // Добавить здесь логику для сохранения данных
                            }
                        }
                        .alert(isPresented: $showErrorAlert) {
                            Alert(title: Text("Ошибка"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(image: $modelData.registrationData.photo)
                    }
                    
                    Spacer()
                }
                .alert(isPresented: $isRegistrationCancelled) {
                    Alert(
                        title: Text("Отменить регистрацию?"),
                        primaryButton: .default(Text("Да")) {
                            // Сброс данных перед возвращением к WelcomeView
                            modelData.registrationData = RegistrationData()
                            // Возвращение к WelcomeView
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    RegistrationView()
        .environmentObject(ModelData())
}
