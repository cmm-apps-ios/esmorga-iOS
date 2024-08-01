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
            AF.request(url,
                       method: networkService.method,
                       parameters: networkService.parameters,
                       headers: networkService.headers,
                       requestModifier: { $0.timeoutInterval = self.requestTimeout })
            .responseData { response in
                print(response.request ?? "")
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
                            return .genaralError(code: errorCode)
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
