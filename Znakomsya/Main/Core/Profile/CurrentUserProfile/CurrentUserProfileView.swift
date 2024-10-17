import SwiftUI

struct CurrentUserProfileView: View {
    @State private var showEditProfile = false
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var viewModel: LoginViewModel
    
    var body: some View {
        NavigationStack {
            List {
                // header view
                CurrentUserProfileHeaderView()
                    .environmentObject(modelData)
                    .onTapGesture {
                        showEditProfile.toggle()
                    }
                
                // account info
                Section("Account Info") {
                    HStack {
                        Text("Name")
                        
                        Spacer()
                        
                        Text(modelData.profileData.name)
                    }
                    
                    HStack {
                        Text("Email")
                        
                        Spacer()
                        
                        Text(modelData.profileData.email)
                    }
                }
                
                // legal
                Section("Legal") {
                    Text("Terms of Service")
                }
                
                // logout/delete
                Section {
                    Button ("Logout"){
                        viewModel.logout()
                    }
                    .foregroundStyle(.red)
                }
                    
                Section {
                    Button ("Delete account"){
                        print("DEBUG: Delete account..")
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showEditProfile) {
                EditProfileView().environmentObject(modelData)
            }
        }
    }
}

#Preview {
    CurrentUserProfileView().environmentObject(ModelData())
}
