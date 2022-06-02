import SwiftUI

struct ArtistsAdminView: View {
    
    @StateObject private var artistVM = ArtistListAdminVM(service: ArtistService())
    
    var body: some View {
        VStack {
            Group {
                switch artistVM.state {
                case .success:
                    List(artistVM.artists, id:\.id){ artist in
                        ArtistCellAdminView(artist: artist)
                    }
                    .refreshable{
                        Task{
                            await artistVM.getArtists()
                        }
                    }
                case .loading :
                    LoadingView(text: "Fetching Artists")
                default:
                    EmptyView()
                }
            }
        }
        .navigationTitle("Artistseee")
        .task{
            await artistVM.getArtists()
        }
        .alert("Error",
               isPresented:  $artistVM.hasError,
               presenting: artistVM.state) {detail in
            Button(action:{
                Task {
                    await artistVM.getArtists()
                }}
                   ,label:{
                Text("Retry")}
            )
        } message : {detail in
            if case let .failed(error) = detail {
                Text(error)
            }
        }
    }
}

struct ArtistsAdminView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistsAdminView()
    }
}
