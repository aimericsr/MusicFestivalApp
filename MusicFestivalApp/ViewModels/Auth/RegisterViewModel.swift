import Foundation

protocol RegisterViewModelProt: ObservableObject {
    func register() async
}

@MainActor
final class RegisterViewModel : RegisterViewModelProt {
    enum State {
        case na
        case loading
        case success
        case failed(error: Error)
    }
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var email: String = ""
    
    @Published private(set) var state : State = .na
    @Published var hasError : Bool = false
    
    private let service: AuthServiceProt
    
    init(service: AuthServiceProt){
        self.service = service
    }
    
    func register() async{
        self.state = .loading
        self.hasError = false
        do {
            try await service.register(username: self.username, password: self.password, email: self.email)
            self.state = .success
        }catch{
            self.state = .failed(error: error)
            self.hasError = true
        }
    }
    
    //validation data from form
    func passwordsMatch() -> Bool {
        self.password == self.confirmPassword
    }
    
    //Minimum eight characters, at least one uppercase letter, one lowercase letter and one number:
    func isPasswordValid() -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    // send an email instead
    func isEmailValid() -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@",
        "^((([!#$%&'*+\\-/=?^_`{|}~\\w])|([!#$%&'*+\\-/=?^_`{|}~\\w][!#$%&'*+\\-/=?^_`{|}~\\.\\w]{0,}[!#$%&'*+\\-/=?^_`{|}~\\w]))[@]\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*)$")
        return emailTest.evaluate(with: email)
    }
    
    func isUsernameValid() -> Bool {
        self.username.count > 8
    }
    
    var isRegisterComplete: Bool {
        if (!passwordsMatch() || !isPasswordValid() || !isEmailValid() || !isUsernameValid()){
            return false
        }
        return true
    }
    
    //prompt string
    var confirmPwPrompt: String {
        if passwordsMatch(){
            return ""
        }else {
            return "Password fiels do not match"
        }
    }
    
    var emailPrompt: String {
        if isEmailValid(){
            return ""
        }else {
            return "Enter a valid email address"
        }
    }
    
    var usernamePrompt: String {
        if isUsernameValid(){
            return ""
        }else {
            return "Username must be at least 8 characters"
        }
    }
    
    var passwordPrompt: String {
        if isPasswordValid(){
            return ""
        }else {
            return "Minimum 8 characters, at least 1 uppercase letter and 1 lowercase letter and 1 number:"
        }
    }
}
