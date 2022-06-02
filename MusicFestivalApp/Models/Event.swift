//
//  Event.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import Foundation

struct Event : Codable {
    let id: UUID
    let name: String
    let location: String
    let started_date: Date
    let finish_date: Date
}

extension Event {
    static let dummyData: [Event] = [
        Event(id: UUID(uuidString: "35564e6b-e9f3-4810-aa2e-f118c33cb1c1")!, name: "name1", location: "location1", started_date: DateFormatter().date(from: "2018-02-29 12:24:26")!, finish_date: DateFormatter().date(from: "2018-02-29 12:24:26")!),
        Event(id: UUID(uuidString: "35564e6b-e9f3-4810-aa2e-f118c33cb1c2")!, name: "name2", location: "location2", started_date: DateFormatter().date(from: "2019-02-29 12:24:26")!, finish_date: DateFormatter().date(from: "2019-02-29 12:24:26")!),
        Event(id: UUID(uuidString: "35564e6b-e9f3-4810-aa2e-f118c33cb1c3")!, name: "name3", location: "location3", started_date: DateFormatter().date(from: "2020-02-29 12:24:26")!, finish_date: DateFormatter().date(from: "20120-02-29 12:24:26")!),
        Event(id: UUID(uuidString: "35564e6b-e9f3-4810-aa2e-f118c33cb1c4")!, name: "name4", location: "location3", started_date: DateFormatter().date(from: "2021-02-29 12:24:26")!, finish_date: DateFormatter().date(from: "2021-02-29 12:24:26")!)
    ]
}
