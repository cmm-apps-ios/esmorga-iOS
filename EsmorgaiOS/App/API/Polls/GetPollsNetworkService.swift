//
//  EventsNetworkService.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import Foundation
import Alamofire

enum PollsNetworkService: NetworkService {

    case pollsList

    var url: URL { URL(string: "\(Bundle.baseURL)/v1")! }

    var path: String {
        switch self {
        case .pollsList: return "/polls"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .pollsList: return .get
        }
    }

    var parameters: [String : Any]? { nil }
    var headers: HTTPHeaders { ["Content-Type": "application/json"] }
    var body: Data? { nil }
    var requestInterceptor: RequestInterceptor? {
        switch self {
        case .pollsList:
            return AuthenticationInterceptor(authenticator: AccountAuthenticator(),
                                             credential: AccountCredential())
        }
    }
}
