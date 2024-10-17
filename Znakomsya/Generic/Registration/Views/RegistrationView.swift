import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var confirmPassword = ""
    @State private var navigateToAuthorization = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isKeyboardVisible = false
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(red: 1, green: 0.89, blue: 0.89).opacity(0.60))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color(red: 0.22, green: 0.23, blue: 0.25))], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color(red: 0.28, green: 0.28, blue: 0.29).opacity(0.70))], for: .normal)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Image("bg_img")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    
                    GeometryReader { geometry in
                        HStack {
                            Color.clear
                                .contentShape(Rectangle())
                                .frame(width: geometry.size.width / 7)
                                .gesture(
                                    DragGesture().onEnded { value in
                                        if value.translation.width > 20 {
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                )
                            Spacer()
                        }
                    }
                    
                    VStack (spacing: 30) {
                        
                        Text("Регистрация")
                            .frame(width: 180, height: 43)
                            .font(Font.custom("Montserrat-Medium", size: 26))
                            .foregroundColor(Color(red: 0.22, green: 0.23, blue: 0.25))
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 340, height: 505)
                                .background(Color(red: 1, green: 0.90, blue: 0.90).opacity(0.35))
                                .cornerRadius(30)
                            
                            // Стек для заполняемых полей
                            VStack {
                                // Стек для имени
                                VStack (alignment: .leading){
                                    HStack (spacing: 10) {
                                        Image("name_img")
                                        TextField("Имя", text: $modelData.registrationData.name)
                                            .font(Font.custom("Montserrat-Meduim", size: 18))
                                            .foregroundColor(Color(red: 0.22, green: 0.23, blue: 0.25))
                                            .frame(width: 230)
                                    }
                                    Rectangle ()
                                        .frame(width: 280, height: 1)
                                        .foregroundColor(.clear)
                                        .background(Color(.black).opacity(0.4))
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                                
                                // Стек для пола
                                VStack {
                                    HStack (spacing: 10) {
                                        Image("male_img")
                                            .opacity(0.6)
                                        
                                        Picker("", selection: $modelData.registrationData.sex) {
                                            Text("Мужской").tag("М")
                                            Text("Женский").tag("Ж")
                                        }
                                        .pickerStyle(SegmentedPickerStyle())
                                        .frame(width: 208)
                                        
                                        Image("female_img")
                                            .opacity(0.6)
                                    }
                                    Rectangle ()
                                        .frame(width: 280, height: 1)
                                        .foregroundColor(.clear)
                                        .background(Color(.black).opacity(0.4))
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                                
                                // Стек для даты
                                VStack (alignment: .leading){
                                    HStack (spacing: 10) {
                                        Image("calendar_img")
                                            .opacity(0.6)
                                        DatePicker ("Дата ", selection: $modelData.registrationData.date_of_birth, in: ...Date(), displayedComponents: .date)
                                            .frame(width: 220)
                                            .font(.custom("Montserrat-Light", size: 16))
                                            .foregroundColor(Color(red: 0.28, green: 0.28, blue: 0.29).opacity(0.70))
                                            .multilineTextAlignment(.center)
                                    }
                                    Rectangle ()
                                        .frame(width: 280, height: 1)
                                        .foregroundColor(.clear)
                                        .background(Color(.black).opacity(0.4))
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                                
                                // Стек для почты
                                VStack (alignment: .leading){
                                    HStack (spacing: 10) {
                                        Image("mail_img")
                                            .opacity(0.6)
                                        TextField("Почта", text: $modelData.registrationData.email)
                                            .font(Font.custom("Montserrat-Meduim", size: 18))
                                            .foregroundColor(Color(red: 0.22, green: 0.23, blue: 0.25))
                                            .frame(width: 230)
                                            .autocapitalization(.none)
                                            .keyboardType(.emailAddress)
                                    }
                                    Rectangle ()
                                        .frame(width: 280, height: 1)
                                        .foregroundColor(.clear)
                                        .background(Color(.black).opacity(0.4))
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                                
                                // Стек для телефона
                                VStack (alignment: .leading){
                                    HStack (spacing: 10) {
                                        Image("phone_img")
                                            .opacity(0.6)
                                        TextField("Номер телефона", text: $modelData.registrationData.phone_number)
                                            .keyboardType(.phonePad)
                                            .font(Font.custom("Montserrat-Meduim", size: 18))
                                            .foregroundColor(Color(red: 0.22, green: 0.23, blue: 0.25))
                                            .frame(width: 230)
                                            .phoneNumberFormat(text: $modelData.registrationData.phone_number)
                                    }
                                    Rectangle ()
                                        .frame(width: 280, height: 1)
                                        .foregroundColor(.clear)
                                        .background(Color(.black).opacity(0.4))
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                                
                                // Стек для пароля
                                VStack (alignment: .leading){
                                    HStack (spacing: 10) {
                                        Image("pass_img")
                                            .opacity(0.6)
                                        SecureField("Введите пароль", text: $modelData.registrationData.password)
                                            .font(Font.custom("Montserrat-Meduim", size: 18))
                                            .foregroundColor(Color(red: 0.22, green: 0.23, blue: 0.25))
                                            .frame(width: 230)
                                    }
                                    Rectangle ()
                                        .frame(width: 280, height: 1)
                                        .foregroundColor(.clear)
                                        .background(Color(.black).opacity(0.4))
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                                
                                // Стек для подтверждения пароля
                                VStack (alignment: .leading){
                                    HStack (spacing: 10) {
                                        Image("pass_img")
                                            .opacity(0.6)
                                        SecureField("Подтвердите пароль", text: $confirmPassword)
                                            .font(Font.custom("Montserrat-Meduim", size: 18))
                                            .foregroundColor(Color(red: 0.22, green: 0.23, blue: 0.25))
                                            .frame(width: 230)
                                    }
                                    Rectangle ()
                                        .frame(width: 280, height: 1)
                                        .foregroundColor(.clear)
                                        .background(Color(.black).opacity(0.4))
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 15)
                                
                                // Стек для кнопки
                                Button(action: {
                                    if let errorMessage = modelData.registrationData.validationError(check: confirmPassword) {
                                        showAlert = true
                                        alertMessage = errorMessage
                                    } else {
                                        modelData.registerUser { result in
                                            switch result {
                                            case .success:
                                                navigateToAuthorization = true
                                            case .failure(let error):
                                                showAlert = true
                                                alertMessage = error.localizedDescription
                                            }
                                        }
                                    }
                                }
                                ) {
                                    Text("Регистрация")
                                        .foregroundColor(Color(red: 0.22, green: 0.23, blue: 0.25))
                                        .font(.custom("Montserrat-Medium", size: 18))
                                        .padding(.vertical)
                                        .padding(.horizontal, 50)
                                        .frame(width: 240)
                                        .background(Color(red: 1, green: 0.89, blue: 0.89).opacity(0.60))
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Ошибка"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .gesture(DragGesture().onChanged({ _ in
                hideKeyboard()
            }))
            .ignoresSafeArea(.keyboard)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    {
                        Image(systemName: "arrowshape.turn.up.left.fill")
                            .foregroundColor(Color(red: 0.28, green: 0.28, blue: 0.29).opacity(0.90))
                    }
                }
            }
            NavigationLink(destination: AuthorizationView().environmentObject(modelData), isActive: $navigateToAuthorization) {
                EmptyView()
            }
        }
        .navigationDestination(isPresented: $navigateToAuthorization) {
            AuthorizationView().environmentObject(modelData)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // Функция для скрытия клавиатуры
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    RegistrationView()
        .environmentObject(ModelData())
}
