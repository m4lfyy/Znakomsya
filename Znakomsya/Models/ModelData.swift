import SwiftUI

class ModelData: ObservableObject {
    @Published var registrationData: RegistrationData = RegistrationData()
}
