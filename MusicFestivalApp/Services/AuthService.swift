//
//  WebService.swift
//  MusicFestivalApp
//
//  Created by Aimeric Sorin on 10/12/2021.
//

enum AuthServiceError : Error {
    //case serverUnreachable
    case badFormatResponse
    case invalidCredentials
    case internalServerError
    case unknowStatusCodeError(statusCode: Int)
}

struct LoginRequestBody : Codable {
    let username: String
    let password: String
}

struct LoginResponseBody : Codable {
    let accessToken: String?
    let refreshToken: String?
}

struct RegisterRequestBody : Codable {
    let username: String
    let password: String
    let email: String
}

import Foundation

protocol AuthServiceProt {
    func login(username: String, password: String) async throws -> LoginResponseBody
    func register(username: String, password: String, email: String) async throws -> Void
}

final class AuthService : AuthServiceProt{
    func login(username: String, password: String) async throws -> LoginResponseBody {
        let loginBody = LoginRequestBody(username: username, password: password)
        var request = URLRequest(url: URL(string: APIConstants.baseURL.appending("/auth/login"))!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(loginBody)
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw AuthServiceError.badFormatResponse
            }
            switch response.statusCode {
            case 200:
                return try JSONDecoder().decode(LoginResponseBody.self, from: data)
            case 404:
                throw AuthServiceError.invalidCredentials
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
    
    func register(username: String, password: String, email: String) async throws -> Void {
        let registerBody = RegisterRequestBody(username: username, password: password, email: email)
        var request = URLRequest(url: URL(string: APIConstants.baseURL.appending("/auth/register"))!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(registerBody)
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
