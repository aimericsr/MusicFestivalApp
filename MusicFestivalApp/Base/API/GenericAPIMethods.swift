import Foundation

enum GenericServiceError : Error {
    //case serverUnreachable
    case badFormatResponse
    case unauthorizedError
    case internalServerError
    case unknowStatusCodeError(statusCode: Int)
}

struct GenericAPIMethods {
    static func fetchAll<T : Codable>(url: String, jwt: String) async throws -> [T] {
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("Bearer \(jwt)",forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw GenericServiceError.badFormatResponse
            }
            switch response.statusCode {
                case 200:
                    return try JSONDecoder().decode([T].self, from: data)
                case 401:
                    throw GenericServiceError.unauthorizedError
                case 500:
                    throw GenericServiceError.internalServerError
                default:
                    throw GenericServiceError.unknowStatusCodeError(statusCode: response.statusCode)
            }
        }catch {
            throw error
            //throw GenericServiceError.serverUnreachable
        }
    }
    
    static func post<T : Codable>(url: URL, jwt: String, requestBody: T) async throws -> Void {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(jwt)",forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)
        do{
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw GenericServiceError.badFormatResponse
            }
            switch response.statusCode {
            case 201:
                return
            case 401:
                throw GenericServiceError.unauthorizedError
            case 500:
                throw GenericServiceError.internalServerError
            default:
                throw GenericServiceError.unknowStatusCodeError(statusCode: response.statusCode)
            }
        }catch {
            throw error
            //throw GenericServiceError.serverUnreachable
        }
    }
    
    static func postWithBodyResponse<T : Codable, U : Codable>(url: URL,successCode: Int, jwt: String, requestBody: T) async throws -> U {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(jwt)",forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw GenericServiceError.badFormatResponse
            }
            switch response.statusCode {
            case successCode:
                return try JSONDecoder().decode(U.self, from: data)
            case 401:
                throw GenericServiceError.unauthorizedError
            case 500:
                throw GenericServiceError.internalServerError
            default:
                throw GenericServiceError.unknowStatusCodeError(statusCode: response.statusCode)
            }
        }catch {
            throw error
            //throw GenericServiceError.serverUnreachable
        }
    }
}

