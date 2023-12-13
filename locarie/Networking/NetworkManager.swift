//
//  NetworkManager.swift
//  locarie
//
//  Created by qiuty on 09/12/2023.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    private func completionHandler(data: Data?, response: URLResponse?, error: Error?,
                                   completion: @escaping (Result<Data, Error>) -> Void)
    {
        if let error {
            completion(.failure(error))
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NetworkError.unknownResponse(description: response?.description)))
            return
        }
        guard (200 ... 299).contains(httpResponse.statusCode) else {
            completion(.failure(NetworkError.badStatusCode(httpResponse.statusCode)))
            return
        }
        guard let data else {
            completion(.failure(NetworkError.emptyData))
            return
        }
        completion(.success(data))
    }

    // request with method GET/DELETE
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        NetworkConfig.shared.urlSession.dataTask(with: url) { data, response, error in
            self.completionHandler(data: data, response: response, error: error, completion: completion)
        }.resume()
    }

    // request with method POST/PUT/PATCH
    func request(httpRequest: HttpRequest<some Encodable>, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: httpRequest.url)
        request.httpMethod = httpRequest.method.rawValue
        request.setValue(httpRequest.contentType.rawValue, forHTTPHeaderField: "Content-Type")
        do {
            let bodyData = try JSONEncoder().encode(httpRequest.body)
            NetworkConfig.shared.urlSession.uploadTask(with: request, from: bodyData) { data, response, error in
                self.completionHandler(data: data, response: response, error: error, completion: completion)
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}

enum HttpMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH

    func isUploadData() -> Bool {
        self == .POST || self == .PUT || self == .PATCH
    }
}

enum HttpContentType: String {
    case json = "application/json"
    case xml = "application/xml"
    case html = "text/html"
    case plain = "text/plain"
    case form = "multipart/form-data"
}

struct HttpRequest<T: Encodable> {
    let url: URL
    let method: HttpMethod
    let contentType: HttpContentType
    let body: T?
}
