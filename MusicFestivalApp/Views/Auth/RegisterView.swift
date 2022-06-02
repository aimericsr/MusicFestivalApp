import SwiftUI

struct RegisterView: View {
    @StateObject private var registerVM = RegisterViewModel(service: AuthService())
    
    var body: some View {
            VStack{
                Form{
                    Section(header: Text("USERNAME")){
                            TextField("Username", text: $registerVM.username){
                        }
                        if(!registerVM.isUsernameValid()){
                            Text(registerVM.usernamePrompt)
                                .font(.caption)
                        }
                    }
                    Section(header: Text("PASSWORD")){
                        SecureField("Password", text: $registerVM.password)
                        if(!registerVM.isPasswordValid()){
                            Text(registerVM.passwordPrompt)
                                .font(.caption)
                        }
                        SecureField("Confirm Password", text: $registerVM.confirmPassword)
                        if(!registerVM.passwordsMatch()){
                            Text(registerVM.confirmPwPrompt)
                                .font(.caption)
                        }
                    }
                    Section(header: Text("EMAIL")){
                        TextField("Email", text: $registerVM.email)
                        if(!registerVM.isEmailValid()){
                            Text(registerVM.emailPrompt)
                                .font(.caption)
                        }
                    }
                }.textInputAutocapitalization(.never)
                
                Button(action : {
                    Task{
                        await registerVM.register()
                        print("kljfs")
                    }
                },label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 60)
                        .overlay(
                            Text("Register")
                                .foregroundColor(.white)
                        )
                }).padding()
                
            
                    .disabled(!registerVM.isRegisterComplete)
                
                    
            }.navigationTitle("Register")
            
        
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
