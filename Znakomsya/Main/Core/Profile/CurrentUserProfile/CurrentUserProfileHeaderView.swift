import SwiftUI

struct CurrentUserProfileHeaderView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                if let uiImage = modelData.profileData.photo {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .background {
                            Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 128, height: 128)
                                .shadow(radius: 10)
                        }}
                
                Image(systemName: "pencil")
                    .imageScale(.small)
                    .foregroundStyle(.gray)
                    .background {
                        Circle()
                            .fill(.white)
                            .frame(width: 32, height: 32)
                    }
                    .offset(x: -8, y: 10)
            }
            Text("\(modelData.profileData.name), ")
                .font(Font.custom("Montserrat-Bold", size: 22)) +
            Text("\(modelData.profileData.age)")
                .font(Font.custom("Montserrat-MediumItalic", size: 22))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
    }
}

#Preview {
    CurrentUserProfileHeaderView().environmentObject(ModelData())
}
