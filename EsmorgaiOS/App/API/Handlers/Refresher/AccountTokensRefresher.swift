//
//  AccountTokensRefresher.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 17/9/24.
//

import Foundation
import Alamofire

class AccountTokensRefresher: TokensRefresher {

    typealias Token = AccountCredential

    struct RefreshTokens: Codable {
        let accessToken: String
        let refreshToken: String
        let ttl: Double
    }

    func refreshTokens(sessionManager: Alamofire.Session,
                       credential: AccountCredential,
                       completion: @escaping (_ succeeded: Bool, _ responseCode: Int, _ error: Error?) -> Void) {

        guard let refreshToken = credential.refreshToken else {
            completion(false, 401, nil)
            return
        }

        let networkService = AccountNetworkService.refresh(token: refreshToken)
        let url = networkService.url.appending(path: networkService.path)
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .useProtocolCachePolicy)

        urlRequest.headers = networkService.headers
        urlRequest.method = networkService.method
        urlRequest.httpBody = networkService.body

        sessionManager.request(urlRequest)
            .validate()
            .responseDecodable(of: AccountTokensRefresher.RefreshTokens.self) { [weak self] response in
                guard let self else { return }

                let statusCode = response.response?.statusCode ?? 0
                switch response.result {
                case .success(let tokens):
                    do {

                        let newAccountSession = AccountSession(accessToken: tokens.accessToken,
                                                               refreshToken: tokens.refreshToken,
                                                               ttl: tokens.ttl)

                        try credential.store(tokens: newAccountSession)
                        completion(true, statusCode, nil)
                    } catch {
                        completion(false, statusCode, nil)
                    }
                case .failure(let error):
                    self.processError(error, statusCode: statusCode, completion: completion)
                }
            }
    }

    private func processError(_ error: AFError, statusCode: Int, completion: @escaping (_ succeeded: Bool, _ responseCode: Int, _ error: Error?) -> Void) {
        switch error {
        case .sessionTaskFailed(let error) where error.code == NSURLErrorNotConnectedToInternet:
            completion(false, error.code, error)
        default:
            completion(false, statusCode, error)
        }
    }
}
