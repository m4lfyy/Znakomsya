import SwiftUI
import UIKit

struct RegistrationView: View {
    @Binding var registrationData: RegistrationData
    @State private var selectedImage: Image?
    @State private var isImagePickerPresented: Bool = false
    @State private var isNextViewActive: Bool = false

    var body: some View {
        NavigationView {
            Form {
                TextField("Имя", text: $registrationData.name)
                DatePicker("Дата рождения", selection: $registrationData.birthDate, displayedComponents: .date)
                TextField("Пол", text: $registrationData.gender)
                TextField("Город", text: $registrationData.city)
                TextField("Номер телефона", text: $registrationData.phoneNumber)

                Button("Выбрать фото") {
                    isImagePickerPresented.toggle()
                }
                .imagePicker(isPresented: $isImagePickerPresented, image: $selectedImage)

                Button("Далее") {
                    // Сохраняем выбранное изображение в RegistrationData
                    registrationData.photo = getImageData(from: selectedImage)
                    isNextViewActive = true
                }
                .padding()
            }
            .padding()
            .navigationBarTitle("Регистрация", displayMode: .inline)
        }
    }

    private func getImageData(from image: Image?) -> Data? {
        guard let uiImage = uiImageFromImage(image) else {
            return nil
        }
        return uiImage.pngData()
    }

    private func uiImageFromImage(_ image: Image?) -> UIImage? {
        // Преобразуем Image в UIImage
        guard let cgImage = image?.cgImage else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

// Оставьте также расширение для ImagePicker, чтобы добавить поддержку Image
extension View {
    func imagePicker(isPresented: Binding<Bool>, image: Binding<Image?>) -> some View {
        return self.modifier(ImagePickerView(isPresented: isPresented, image: image))
    }
}

// Оставьте остальные расширения без изменений

#Preview {
    RegistrationView()
}

