import Foundation

struct ArtistViewModel {
    let artist : Artist
    
    init(artist: Artist){
        self.artist = artist
    }
    
    var id: UUID {
        return self.artist.id
    }
    var name: String {
        return self.artist.name
    }
    var nationality: String {
        return self.artist.nationality
    }
    var musicStyles: String {
        return self.artist.music_styles
    }
}
