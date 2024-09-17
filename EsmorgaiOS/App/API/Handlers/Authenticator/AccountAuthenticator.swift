//
//  AccountAuthenticator.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 16/9/24.
//

import Foundation
import UIKit.UIApplication
import Alamofire

enum AccountAuthenticatorError: Error {
    case refresh
}
class AccountAuthenticator: Authenticator {

    private let lock = NSLock()
    private var taskId: UIBackgroundTaskIdentifier = .invalid
    private let refresher: AccountTokensRefresher

    init(refresher: AccountTokensRefresher = AccountTokensRefresher()) {
        self.refresher = refresher
    }

    func apply(_ credential: AccountCredential, to urlRequest: inout URLRequest) {

        lock.lock()
        defer { lock.unlock() }

        if let accessToken = credential.accessToken {
            urlRequest.setBearerToken(accessToken)
        }
    }

    func refresh(_ credential: AccountCredential, for session: Alamofire.Session, completion: @escaping (Result<AccountCredential, Error>) -> Void) {

        lock.lock()

        taskId = UIApplication.shared.beginBackgroundTask(withName: "Account refresh tasks") {
            self.finishSSOBackgroundTask()
        }

        refresher.refreshTokens(sessionManager: session, credential: credential) { [weak self] (success, responseCode, error) in
            guard let self = self else { return }
            self.finishSSOBackgroundTask()
            self.lock.unlock()
            if success {
                completion(.success(credential))
            } else if responseCode == 401 {
                NotificationCenter.default.post(name: .forceLogout, object: nil)
            } else {
                completion(.failure(AccountAuthenticatorError.refresh))
            }
        }
    }

    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {

        lock.lock()
        defer { lock.unlock() }

        return response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: AccountCredential) -> Bool {

        lock.lock()
        defer { lock.unlock() }

        return urlRequest.getBearerToken() == credential.accessToken
    }

    private func finishSSOBackgroundTask() {

        guard taskId != .invalid else { return }

        UIApplication.shared.endBackgroundTask(taskId)
        taskId = .invalid
    }
}
