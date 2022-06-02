import SwiftUI

struct LoginView: View {
    @StateObject private var loginVM = LoginViewModel(service: AuthService())
    
    var body: some View {
        VStack {
            NavigationView{
                VStack{
                    Form{
                        Section(header: Text("USERNAME")){
                            TextField("Username", text: $loginVM.username)
                        }
                        Section(header: Text("PASSWORD")){
                            SecureField("Password", text: $loginVM.password)
                        }
                    }.textInputAutocapitalization(.never)
                    
                    Button(action : {
                        Task{
                            await loginVM.login()
                        }
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 60)
                            .overlay(
                                Text("Login")
                                    .foregroundColor(.white)
                            )
                    }).padding()
                    
                    NavigationLink (destination: RegisterView(), label: {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.purple)
                            .frame(height: 60)
                            .overlay(
                                Text("Create Account")
                                    .foregroundColor(.white)
                            ).padding([.leading, .trailing])
                    })
                    
                    Group{
                        if(loginVM.roleName == "ADMIN" && loginVM.isAuthenticated){
                            NavigationLink(destination: AdminHomeView().navigationBarBackButtonHidden(true), isActive: $loginVM.isAuthenticated) { EmptyView() }
                            
                        }
                        if(loginVM.roleName == "BASIC" && loginVM.isAuthenticated){
                            NavigationLink(destination: UserHomeView().navigationBarBackButtonHidden(true), isActive: $loginVM.isAuthenticated) { EmptyView() }
                        }
                    }
                }.navigationTitle("Login")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
                .preferredColorScheme(.dark)
        }
    }
}


