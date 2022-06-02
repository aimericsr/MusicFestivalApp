import Foundation

protocol ArtistListAdminVMProt : ObservableObject {
    func getArtists() async
    func postArtist(artist : Artist) async
}

//to update data on the main thread which is the UI thread
@MainActor
final class ArtistListAdminVM : ArtistListAdminVMProt {
    enum State {
        case na
        case loading
        case success
        case failed(error: String)
    }
    
    @Published private(set) var state : State = .na
    @Published var hasError : Bool = false
    @Published private(set) var artists : [ArtistViewModel] = []
    private let service: ArtistServiceProt
    private let secureStore: SecureStore
    
    init(service: ArtistServiceProt){
        self.service = service
        self.secureStore = SecureStore()
    }
    
    func getArtists() async{
        self.state = .loading
        self.hasError = false
        do {
            let accessToken = try secureStore.entry(forKey: "accessToken")!
            self.artists = try await service.getArtists(accessToken: accessToken).map(ArtistViewModel.init)
            self.state = .success
        } catch ArtistServiceError.badFormatResponse {
            self.state = .failed(error: "Bad HTTP Format Response Admin")
            self.hasError = true
            NSLog("Bad HTTP Format Response")
        } catch ArtistServiceError.unauthorizedError {
            self.state = .failed(error: "Unauthorized Request")
            print("server request token invalid Admin")
            self.hasError = true
            NSLog("Unauthorized Request")
        } catch ArtistServiceError.internalServerError {
            self.state = .failed(error: "Internal Server Error Admin")
            self.hasError = true
            NSLog("Internal Server Error")
        } catch ArtistServiceError.unknowStatusCodeError(let statusCode) {
            self.state = .failed(error: "Unknown Status Code Response : \(statusCode) Admin")
            self.hasError = true
            NSLog("Unknown Status Code Response : \(statusCode)")
        } catch {
            self.state = .failed(error: "Server Unreachable Admin")
            self.hasError = true
            NSLog("Unknown Error : \(error.localizedDescription)")
        }
    }
    
    func postArtist(artist : Artist) async{
        self.state = .loading
        self.hasError = false
        do {
            let secureStore = SecureStore()
            let accessToken = try secureStore.entry(forKey: "accessToken")!
            try await service.postArtist(artist: artist,jwt: accessToken)
            self.state = .success
        }catch{
            self.state = .failed(error: error.localizedDescription)
            self.hasError = true
        }
    }
}


