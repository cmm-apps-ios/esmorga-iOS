//
//  EventsNetworkService.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import Foundation
import Alamofire

enum EventsNetworkService: NetworkService {
    case eventsList

    var url: URL { URL(string: "https://qa.esmorga.canarte.org/v1")! }

    var path: String {
        switch self {
        case .eventsList: return "/events"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .eventsList: return .get
        }
    }

    var parameters: [String : Any]? { nil }
    var headers: HTTPHeaders { ["Content-Type": "application/json"] }
}
