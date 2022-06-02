//
//  ArtistWebService.swift
//  MusicFestival
//
//  Created by Aimeric Sorin on 10/12/2021.
//

import Foundation

protocol ArtistServiceProt {
    func getArtists(accessToken: String) async throws -> [Artist]
    func postArtist(artist: Artist, jwt: String) async throws -> Void
}

enum ArtistServiceError : Error {
    //case serverUnreachable
    case badFormatResponse
    case unauthorizedError
    case internalServerError
    case unknowStatusCodeError(statusCode: Int)
}

struct ArtistService : ArtistServiceProt {
    func getArtists(accessToken: String) async throws -> [Artist] {
        var request = URLRequest(url: URL(string: APIConstants.baseURL.appending("/artists"))!)
        request.setValue("Bearer \(accessToken)",forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw ArtistServiceError.badFormatResponse
            }
            switch response.statusCode {
                case 200:
                    return try JSONDecoder().decode([Artist].self, from: data)
                case 401:
                    throw ArtistServiceError.unauthorizedError
                case 500:
                    throw ArtistServiceError.internalServerError
                default:
                    throw ArtistServiceError.unknowStatusCodeError(statusCode: response.statusCode)
            }
        }catch {
            throw error
            //throw GenericServiceError.serverUnreachable
        }
    }
    
    func postArtist(artist: Artist, jwt: String) async throws -> Void {
        var request = URLRequest(url: URL(string: APIConstants.baseURL.appending("/auth/register"))!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(artist)
        do{
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw AuthServiceError.badFormatResponse
            }
            switch response.statusCode {
            case 201:
                return
            case 500:
                throw AuthServiceError.internalServerError
            default:
                throw AuthServiceError.unknowStatusCodeError(statusCode: response.statusCode)
            }
        }catch {
            throw error
            //throw GenericServiceError.serverUnreachable
        }
        
    }
}
