import SwiftUI

struct UserMatchView: View {
    @Binding var show: Bool
    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.7))
                .ignoresSafeArea()
            
            VStack(spacing: 90) {
                VStack {
                    Image(.itsamatch)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 100)
                    
                    if let matchedUser = matchManager.matchedUser {
                        Text("You and \(matchedUser.fullname) have liked each other.")
                            .font(Font.custom("Montserrat-BoldItalic", size: 18))
                            .foregroundStyle(.white)
                            .padding(.top)
                    }
                }
                
                HStack(spacing: 16) {
                    let imageArray = modelData.profileData.profileImageArray()
                    if let uiImage = imageArray[0] {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(.white, lineWidth: 2)
                                    .shadow(radius: 4)
                            }
                    }
                    
                    if let matchedUser = matchManager.matchedUser {
                        Image(matchedUser.profileImageURLs[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(.white, lineWidth: 2)
                                    .shadow(radius: 4)
                            }
                    }
                }
                
                VStack {
                    Button("Keep Swiping") {
                        show.toggle()
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 350, height: 44)
                    .background(Color(red: 0.96, green: 0.31, blue: 0.31))
                    .clipShape(Capsule())
                }
            }
        }
    }
}

#Preview {
    UserMatchView(show:  .constant(true))
        .environmentObject(MatchManager()).environmentObject(ModelData())
}
