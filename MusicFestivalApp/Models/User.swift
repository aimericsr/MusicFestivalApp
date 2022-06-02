//
//  User.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import Foundation

struct User : Codable {
    let id: UUID
    let username: String
    let email: String
    let created_on: Date
}

extension User {
    static let dummyData: [User] = [
        User(id: UUID(uuidString: "35564e6b-e9f3-4810-aa2e-f118c33cb1c1")!, username: "username1", email: "email1@gmail.com", created_on: DateFormatter().date(from: "2016-02-29 12:24:26")!),
        User(id: UUID(uuidString: "48564e6b-e9f3-4810-aa2e-f118c33cb1c1")!, username: "username2", email: "email2@gmail.com", created_on: DateFormatter().date(from: "2018-02-29 12:24:26")!),
        User(id: UUID(uuidString: "55564e6b-e9f3-4810-aa2e-f118c33cb1c1")!, username: "username3", email: "email3@gmail.com", created_on: DateFormatter().date(from: "2019-02-29 12:24:26")!),
        User(id: UUID(uuidString: "68564e6b-e9f3-4810-aa2e-f118c33cb1c1")!, username: "username4", email: "email4@gmail.com", created_on: DateFormatter().date(from: "2020-02-29 12:24:26")!)
    ]
}
