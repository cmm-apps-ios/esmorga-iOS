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
    case eventAttendees(eventId: String)

    var url: URL { URL(string: "\(Bundle.baseURL)/v1")! }

    var path: String {
        switch self {
        case .eventsList: return "/events"
        case .eventAttendees(let eventId): return "/events/\(eventId)/users"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .eventsList, .eventAttendees(_): return .get
        }
    }

    var parameters: [String : Any]? { nil }
    var headers: HTTPHeaders { ["Content-Type": "application/json"] }
    var body: Data? { nil }
    var requestInterceptor: RequestInterceptor? { nil }
}
