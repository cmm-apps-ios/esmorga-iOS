//
//  AccountNetworkService.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 20/8/24.
//

import Foundation
import Alamofire

enum AccountNetworkService: NetworkService {

    case login(pass: String, email: String)

    var url: URL { URL(string: "https://qa.esmorga.canarte.org/v1")! }

    var path: String {
        switch self {
        case .login: return "account/login"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login: return .post
        }
    }

    var parameters: [String : Any]? { nil }
    var headers: HTTPHeaders { ["Content-Type": "application/json"] }
    
    var body: Data? {
        switch self {
        case .login(let pass, let email):
            let json = ["password": pass,
                        "email": email]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        }
    }
}
