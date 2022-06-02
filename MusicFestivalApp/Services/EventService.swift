//
//  ArtistWebService.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import Foundation

protocol EventServiceProt {
    func getEvents(accessToken: String) async throws -> [Event]
}

enum EventServiceError : Error {
    //case serverUnreachable
    case badFormatResponse
    case unauthorizedError
    case internalServerError
    case unknowStatusCodeError(statusCode: Int)
}

struct EventService : EventServiceProt {
    func getEvents(accessToken: String) async throws -> [Event] {
        var request = URLRequest(url: URL(string: APIConstants.baseURL.appending("/events"))!)
        request.setValue("Bearer \(accessToken)",forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        //custom formater to be able to format the date with the fraticonal seconds part
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)

        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw EventServiceError.badFormatResponse
            }
            switch response.statusCode {
                case 200:
                return try decoder.decode([Event].self, from: data)
                case 401:
                    throw EventServiceError.unauthorizedError
                case 500:
                    throw EventServiceError.internalServerError
                default:
                    throw EventServiceError.unknowStatusCodeError(statusCode: response.statusCode)
            }
        }catch {
            print(error)
            NSLog(error.localizedDescription)
            throw error
            
            //throw GenericServiceError.serverUnreachable
        }
    }
}
