//
//  Artist.swift
//  MusicFestivalApp
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import Foundation

struct Artist : Codable {
    let id: UUID
    let name: String
    let nationality: String
    let music_styles: String

}

extension Artist {
    static let dummyData: [Artist] = [
        Artist(id: UUID(uuidString: "35564e6b-e9f3-4810-aa2e-f118c33cb1c1")!, name: "username1", nationality: "email1@gmail.com", music_styles: "styles1"),
        Artist(id: UUID(uuidString: "35564e6b-e9f3-4810-aa2e-f118c33cb1c5")!, name: "username2", nationality: "email12gmail.com", music_styles: "styles2"),
        Artist(id: UUID(uuidString: "35564e6b-e9f3-4810-aa2e-f118c33cb1c2")!, name: "username3", nationality: "email3@gmail.com", music_styles: "styles3"),
        Artist(id: UUID(uuidString: "35564e6b-e9f3-4810-aa2e-f118c33cb1c3")!, name: "username4", nationality: "email4@gmail.com", music_styles: "styles4")
    ]
}
