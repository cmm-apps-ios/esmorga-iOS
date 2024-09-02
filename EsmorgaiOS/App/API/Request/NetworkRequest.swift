//
//  NetworkRequest.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import Foundation
import Alamofire

protocol NetworkRequestProtocol {
    func request<T: Codable>(networkService: NetworkService) async throws -> T
}

struct NetworkRequest: NetworkRequestProtocol {

    private let requestTimeout: Double = 30 // Seconds

    func request<T: Codable>(networkService: NetworkService) async throws -> T {
        let url = networkService.url.appending(path: networkService.path)

        return try await withUnsafeThrowingContinuation { continuation in

            var urlRequest = URLRequest(url: url,
                                        cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: self.requestTimeout)
            urlRequest.headers = networkService.headers
            urlRequest.method = networkService.method
            urlRequest.httpBody = networkService.body

            AF.request(urlRequest)
                .validate()
                .responseData(emptyResponseCodes: Set([204, 200, 201])) { response in
                    print(response.request ?? "")
                    print("Request Response: \(response.result)")
                    switch response.result {
                    case .success(let data):
                        print(String(data: data, encoding: .utf8) ?? "")
                        guard let decodeData = try? JSONDecoder().decode(T.self, from: data) else {
                            continuation.resume(throwing: NetworkError.mappingError)
                            return
                        }
                        continuation.resume(returning: decodeData)

                    case .failure(let error):
                        let errorCode = response.response?.statusCode ?? error.underlyingError?.code ?? error.code
                        guard errorCode != NSURLErrorCancelled else { return }
                        var networkError: NetworkError {
                            if errorCode == NSURLErrorNotConnectedToInternet {
                                return .noInternetConnection
                            } else {
                                return .generalError(code: errorCode)
                            }
                        }
                        continuation.resume(throwing: networkError)
                    }
                }

        }
    }
}

extension Error {
    var code: Int { (self as NSError).code }
}