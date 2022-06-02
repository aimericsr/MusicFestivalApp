import Foundation

protocol LoginViewModelProt: ObservableObject {
    func login() async
}

@MainActor
final class LoginViewModel : LoginViewModelProt {
    enum State {
        case na
        case loading
        case success
        case failed(error: Error)
    }
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published private(set) var state : State = .na
    @Published var hasError : Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var isFormValid: Bool = false
    @Published var roleName: String = ""
    @Published var createAccountView: Bool = false
    private let service: AuthServiceProt
    
    init(service: AuthServiceProt){
        self.service = service
    }
    
    func login() async{
        self.state = .loading
        self.hasError = false
        do {
            let loginResponse = try await service.login(username: username, password: password)
            let secureStore = SecureStore()
            let payload = try JsonWebToken.decode(jwtToken: loginResponse.accessToken!)
            let role = payload["role"]!
            self.roleName = String(describing: role)
            try secureStore.set(entry: loginResponse.accessToken!, forKey: "accessToken")
            try secureStore.set(entry: loginResponse.refreshToken!, forKey: "refreshToken")
            print(try secureStore.entry(forKey: "accessToken")!)
            print(try secureStore.entry(forKey: "refreshToken")!)
            self.isAuthenticated = true
            self.state = .success
        }catch{
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
    func signOut(){
        let secureStore = SecureStore()
        do{
            try secureStore.removeEntry(forKey: "accessToken")
            try secureStore.removeEntry(forKey: "refreshToken")
        }catch{
            self.hasError = true
        }
        self.isAuthenticated = false
        
    }
    
}
