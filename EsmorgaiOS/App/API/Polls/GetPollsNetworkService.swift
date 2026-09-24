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
    case sendVote(VotePollRequest)

    var url: URL { URL(string: "\(Bundle.baseURL)/v1")! }

    var path: String {
        switch self {
        case .pollsList: "/polls"
        case .sendVote(let vote): "/vote/\(vote.pollId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .pollsList: .get
        case .sendVote: .post
        }
    }

    var parameters: [String : Any]? { nil }
    var headers: HTTPHeaders { ["Content-Type": "application/json"] }
    var body: Data? {
        switch self {
        case .pollsList: return nil
        case .sendVote(let vote):
            let json = ["selectedOptions": vote.selectedOptionIds]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        }
    }
    var requestInterceptor: RequestInterceptor? {
        switch self {
        case .pollsList, .sendVote(_):
            return AuthenticationInterceptor(authenticator: AccountAuthenticator(),
                                             credential: AccountCredential())
        }
    }
}
