import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var modelData: ModelData
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(red: 1, green: 0.89, blue: 0.89).opacity(0.60))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color(red: 0.22, green: 0.23, blue: 0.25))], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color(red: 0.28, green: 0.28, blue: 0.29).opacity(0.70))], for: .normal)
    }
    
    var body: some View {
        ZStack {
            Group {
                Image("bg_img")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                // Окно ввода
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 340, height: 505)
                    .background(Color(red: 1, green: 0.90, blue: 0.90).opacity(0.35))
                    .cornerRadius(30)
                    .offset(x: 0.50, y: 30.50)
                // Кнопка регистрации
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 280, height: 49)
                    .background(Color(red: 1, green: 0.89, blue: 0.89).opacity(0.60))
                    .cornerRadius(15)
                    .offset(x: 0.50, y: 223.50)
                // Заголовок
                Text("Регистрация")
                    .frame(width: 180, height: 43)
                    .offset(y:-285)
                    .font(Font.custom("Montserrat-Medium", size: 26))
                    .foregroundColor(Color(red: 0.22, green: 0.23, blue: 0.25))
            }
            VStack {
                // Имя
                ZStack(alignment: .leading) {
                    Image("name_img")
                        .offset(x: -15, y: -175)
                    // Затычка на placeholder (заработало без нее)
                    /*if modelData.registrationData.name.isEmpty {
                        Text("Имя")
                            .foregroundColor(Color(red: 0.28, green: 0.28, blue: 0.29).opacity(0.70))
                            .font(Font.custom("Montserrat-Meduim", size: 18))
                            .frame(height: 50)
                            .offset(x: 20, y: -174.50)
                    }*/
                    TextField("Введите имя", text: $modelData.registrationData.name)
                        .font(Font.custom("Montserrat-Meduim", size: 18))
                        .foregroundColor(Color(red: 0.22, green: 0.23, blue: 0.25))
                        .frame(width: 230, height: 50)
                        .offset(x: 20, y: -175)

                    // Пол
                    Image("male_img")
                        .offset(x: -15, y: -114.50)
                        .opacity(0.6)
                    
                        Picker("", selection: $modelData.registrationData.gender) {
                            Text("Мужской").tag("М")
                            Text("Женский").tag("Ж")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200)
                        .offset(x:13, y: -114.50)
                    
                    Image("female_img")
                        .offset(x: 218, y: -114.50)
                        .opacity(0.6)
                }

                Divider()
                    .frame(width: 280)
                    .background(Color.black)
                    .opacity(0.6)
                    .offset(y: -180)
                
            }
        }
    }
}


#Preview {
    RegistrationView()
        .environmentObject(ModelData())
}
