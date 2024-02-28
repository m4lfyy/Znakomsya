import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var isImagePickerPresented = false
    @State private var isRegistrationCancelled = false
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var selectedCity = ""
    @State private var phoneNumber = ""
    
    let cities = Cities.all
    
    private func handlePhoneNumber() {
        if !isValidNumber(phoneNumber) {
            // Обработать случай недопустимого номера телефона
            print("Invalid phone number")
        } else {
            modelData.registrationData.username = phoneNumber
        }
    }

    private func isValidNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^\\+7\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: phoneNumber)
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
                            DatePicker("Дата рождения", selection: $modelData.registrationData.birthDate, in: ...Date(), displayedComponents: .date)
                            Picker("Пол", selection: $modelData.registrationData.gender) {
                                Text("Мужской").tag("М")
                                Text("Женский").tag("Ж")
                            }
                            Picker("Город", selection: $selectedCity) {
                                ForEach(cities, id: \.self) { city in
                                    Text(city)
                                }
                            }
                            .onChange(of: selectedCity) { newValue in
                                modelData.registrationData.city = newValue
                            }
                            TextField("Номер телефона", text: $phoneNumber)
                                .keyboardType(.phonePad)
                                .onAppear {
                                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { _ in
                                        handlePhoneNumber()
                                    }
                                }
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
                                print("Данные: \(modelData.registrationData)")
                                // Добавить здесь логику для сохранения данных
                            }
                            .disabled(!isValidNumber(phoneNumber))
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
