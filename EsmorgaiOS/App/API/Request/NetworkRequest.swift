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

    final class EmptyBodyObject: Codable { }

    static let requestTimeout: Double = 30 // Seconds

    func request<T: Codable>(networkService: NetworkService) async throws -> T {
        let url = networkService.url.appending(path: networkService.path)

        return try await withUnsafeThrowingContinuation { continuation in

            var urlRequest = URLRequest(url: url,
                                        cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                        timeoutInterval: NetworkRequest.requestTimeout)
            urlRequest.headers = networkService.headers
            urlRequest.method = networkService.method
            urlRequest.httpBody = networkService.body

            AF.request(urlRequest, interceptor: networkService.requestInterceptor)
                .validate()
                .responseData(emptyResponseCodes: Set([204, 200/*,201*/])) { response in
                    print("➡️ \(response.request?.cURL ?? "")")
                    switch response.result {
                    case .success(let data):
                        print("✅ \(response.response?.statusCode ?? 0) \n")

                        guard let decodeData = try? CustomJSONDecoder().decode(T.self, from: data) else {
                            continuation.resume(throwing: NetworkError.mappingError)
                            return
                        }
                        continuation.resume(returning: decodeData)

                    case .failure(let error):
                        let errorCode = response.response?.statusCode ?? error.underlyingError?.code ?? error.code
                        print("🛑 \(errorCode)")
                        if let data = response.data {
                            print("⚠️ Error Body: \(String(data: data, encoding: .utf8) ?? "")\n")
                        } else {
                            print("⚠️ Error Body: No data response.\n")
                        }
                
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
