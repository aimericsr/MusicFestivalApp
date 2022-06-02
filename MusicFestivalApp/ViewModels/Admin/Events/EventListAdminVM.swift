import Foundation

protocol EventListAdminVMProt : ObservableObject {
    func getEvents() async
}

//to update data on the main thread which is the UI thread
@MainActor
final class EventListAdminVM : EventListAdminVMProt {
    enum State {
        case na
        case loading
        case success
        case failed(error: String)
    }
    
    @Published private(set) var state : State = .na
    @Published var hasError : Bool = false
    @Published private(set) var events : [EventViewModel] = []
    private let service: EventServiceProt
    private let secureStore: SecureStore
    
    init(service: EventServiceProt){
        self.service = service
        self.secureStore = SecureStore()
    }
    
    func getEvents() async{
        self.state = .loading
        self.hasError = false
        do {
            let accessToken = try secureStore.entry(forKey: "accessToken")!
            print(accessToken)
            self.events = try await service.getEvents(accessToken: accessToken).map(EventViewModel.init)
            self.state = .success
        } catch EventServiceError.badFormatResponse {
            self.state = .failed(error: "Bad HTTP Format Response Admin")
            self.hasError = true
            NSLog("Bad HTTP Format Response")
        } catch EventServiceError.unauthorizedError {
            self.state = .failed(error: "Unauthorized Request")
            print("server request token invalid Admin")
            self.hasError = true
            NSLog("Unauthorized Request")
        } catch EventServiceError.internalServerError {
            self.state = .failed(error: "Internal Server Error Admin")
            self.hasError = true
            NSLog("Internal Server Error")
        } catch EventServiceError.unknowStatusCodeError(let statusCode) {
            self.state = .failed(error: "Unknown Status Code Response : \(statusCode) Admin")
            self.hasError = true
            NSLog("Unknown Status Code Response : \(statusCode)")
        } catch {
            self.state = .failed(error: "Server Unreachable Admin")
            self.hasError = true
            NSLog("Unknown Error : \(error.localizedDescription)")
        }
    }
}


