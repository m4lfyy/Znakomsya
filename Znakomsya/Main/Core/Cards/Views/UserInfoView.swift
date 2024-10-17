import SwiftUI

struct UserInfoView: View {
    @Binding var showProfileModal: Bool
    
    let user: UserInfo
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                Text(user.fullname)
                    .font(Font.custom("Montserrat-ExtraBold", size: 26))
                
                Text("\(user.age)")
                    .font(Font.custom("Montserrat-SemiBoldItalic", size: 26))
                
                Spacer()
                
                Button {
                    showProfileModal.toggle()
                } label: {
                    Image(systemName: "arrow.up.circle")
                        .imageScale(.large)
                        .fontWeight(.bold)
                }
            }
            
            Text("Some test bio for now")
                .font(Font.custom("Montserrat-Medium", size: 15))
                .lineLimit(2)
        }
        .padding()
        .foregroundStyle(.white)
        .background(LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom))
    }
}

#Preview {
    UserInfoView(showProfileModal: .constant(false), user: MockData.users[1])
}

