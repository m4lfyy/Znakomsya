import SwiftUI

struct ProfileImageGridView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(0 ..< 6) { index in
                let imageArray = modelData.profileData.profileImageArray()
                if index < imageArray.count {
                    if let uiImage = imageArray[index] {
                        ZStack (alignment: .bottomTrailing){
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: imageWidth, height: imageHeight)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Image(systemName: "pencil")
                                .imageScale(.medium)
                                .fontWeight(.heavy)
                                .foregroundStyle(.pink)
                                .background {
                                    Circle()
                                        .fill(Color(red: 0.93, green: 0.93, blue: 0.93))
                                        .frame(width: 25, height: 25)
                                }
                                .offset(x: 4, y: 4)
                                .onTapGesture {
                                    isImagePickerPresented = true
                                }
                        }
                    }
                } else {
                    ZStack(alignment: .bottomTrailing){
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.secondarySystemBackground))
                            .frame(width: imageWidth, height: imageHeight)
                        
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.heavy)
                            .foregroundStyle(.pink)
                            .offset(x: 4, y: 4)
                            .onTapGesture {
                                isImagePickerPresented = true
                            }
                    }
                }
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage, onImagePicked: { image in
                if let image = image {
                    modelData.profileData.updateProfilePhoto(image)
                }
                // Сброс состояния после выбора изображения
                selectedImage = nil
            })
        }
    }
}

private extension ProfileImageGridView {
    var columns: [GridItem] {
        [
            .init(.flexible()),
            .init(.flexible()),
            .init(.flexible())
        ]
    }
    
    var imageWidth: CGFloat {
        return 110
    }
    
    var imageHeight: CGFloat {
        return 160
    }
}

#Preview {
    ProfileImageGridView().environmentObject(ModelData())
}
