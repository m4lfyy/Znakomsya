import SwiftUI

struct AuthorizationView: View {
    @StateObject private var viewModel: LoginViewModel
    @EnvironmentObject private var modelData: ModelData

    init() {
        let mockAuthService = MockAuthService()
        let tokenManager = TokenManager()
        _viewModel = StateObject(wrappedValue: LoginViewModel(authService: mockAuthService, tokenManager: tokenManager))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg_img")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                
                VStack (spacing: 30) {
                    Text("Знакомься")
                        .frame(width: 180, height: 43)
                        .font(Font.custom("Montserrat-Medium", size: 26))
                        .foregroundColor(Color(red: 0.22, green: 0.23, blue: 0.25))
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 340, height: 355)
                            .background(Color(red: 1, green: 0.90, blue: 0.90).opacity(0.35))
                            .cornerRadius(30)
                        
                        // Username Field
                        VStack {
                            VStack (alignment: .leading){
                                HStack (spacing: 10) {
                                    Image("name_img")
                                    TextField("Почта", text: $viewModel.loginData.username)
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
                            
                            // Password Field
                            VStack (alignment: .leading){
                                HStack (spacing: 10) {
                                    Image("pass_img")
                                        .opacity(0.6)
                                    SecureField("Пароль", text: $viewModel.loginData.password)
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
                            
                            // Login Button
                            Button(action: {
                                viewModel.loginUser()
                            }
                            ) {
                                Text("Войти")
                                    .foregroundColor(Color(red: 0.22, green: 0.23, blue: 0.25))
                                    .font(.custom("Montserrat-Medium", size: 18))
                                    .padding(.vertical)
                                    .padding(.horizontal, 50)
                                    .frame(width: 240)
                                    .background(Color(red: 1, green: 0.89, blue: 0.89).opacity(0.60))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                            .alert(isPresented: $viewModel.showAlert) {
                                Alert(title: Text("Ошибка"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                            }
                            
                            // Registration and Password Reset
                            VStack (alignment: .leading) {
                                HStack (spacing: 10) {
                                    NavigationLink(destination: RegistrationView().environmentObject(modelData)) {
                                            Text("Регистрация")
                                                .foregroundColor(Color(red: 0.22, green: 0.23, blue: 0.25))
                                                .font(.custom("Montserrat-Medium", size: 16))
                                                .padding(.horizontal, 10)
                                                .padding(.top, 10)
                                    }
                                    
                                    Button(action: {
                                        // Handle password reset
                                    }
                                    ) {
                                        Text("Забыли пароль?")
                                            .foregroundColor(Color(red: 0.22, green: 0.23, blue: 0.25))
                                            .font(.custom("Montserrat-Medium", size: 16))
                                            .padding(.horizontal, 10)
                                    }
                                    .padding(.top, 10)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                            
                            // Alternative Sign-In Options
                            VStack (alignment: .leading) {
                                HStack(spacing: 10) {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .background(Color(.black).opacity(0.4))
                                        .frame(height: 1)
                                    
                                    Text("или")
                                        .font(Font.custom("Montserrat-Meduim", size: 16))
                                        .foregroundColor(Color(red: 0.22, green: 0.23, blue: 0.25))
                                    
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .background(Color(.black).opacity(0.4))
                                        .frame(height: 1)
                                }
                                .padding(.horizontal, 56)
                            }
                            .padding(.bottom, 10)
                            
                            // Social Sign-In Buttons
                            VStack (alignment: .leading) {
                                HStack (spacing: 25) {
                                    Button(action: {
                                        // Implement Google Sign-In
                                    }) {
                                        Image("google_img")
                                            .resizable()
                                            .renderingMode(.original)
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                    }
                                    Button(action: {
                                        
                                    }) {
                                        Image("apple_img")
                                            .resizable()
                                            .renderingMode(.original)
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                    }
                                    Button(action: {
                                        
                                    }) {
                                        Image("vk_img")
                                            .resizable()
                                            .renderingMode(.original)
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 30)
            }
            .gesture(DragGesture().onChanged({ _ in
                hideKeyboard()
            }))
            .ignoresSafeArea(.keyboard)
            .onAppear {
                viewModel.checkExistingToken()
            }
            .navigationDestination(isPresented: $viewModel.navigateToMainTab) {
                MainTabView()
                    .environmentObject(MatchManager())
                    .environmentObject(viewModel)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AuthorizationView()
        .environmentObject(ModelData())
}
