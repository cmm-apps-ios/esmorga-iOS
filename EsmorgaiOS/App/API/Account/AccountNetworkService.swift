//
//  AccountNetworkService.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 20/8/24.
//

import Foundation
import Alamofire

enum AccountNetworkService: NetworkService {

    case myEvents
    case login(pass: String, email: String)
    case register(name: String, lastName: String, pass: String, email: String)
    case verify(email:String)
    case activate(code:String)
    case forgotPassword(email: String)
    case resetPassword(pass: String, code: String)
    case refresh(token: String)
    case join(eventId: String)
    case leave(eventId: String)

    var url: URL { URL(string: "\(Bundle.baseURL)/v1")! }

    var path: String {
        switch self {
        case .login: return "account/login"
        case .register: return "account/register"
        case .verify: return "account/email/verification"
        case .activate: return "account/activate"
        case .forgotPassword: return "account/password/forgot-init"
        case .resetPassword: return "account/password/forgot-update"
        case .refresh: return "account/refresh"
        case .myEvents, .join, .leave: return "account/events"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .myEvents: return .get
        case .leave: return .delete
        case .activate, .resetPassword: return .put
        default: return .post
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
        case .register(let name, let lastName, let pass, let email):
            let json = ["name": name,
                        "lastName": lastName,
                        "password": pass,
                        "email": email]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .verify(let email):
            let json = ["email": email]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .activate(let code):
            let json = ["verificationCode": code]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .forgotPassword(let email):
            let json = ["email": email]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .resetPassword(let pass, let code):
            let json = ["password": pass,
                        "forgotPasswordCode": code]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .refresh(let token):
            let json = ["refreshToken": token]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        case .myEvents: return nil
        case .join(let eventId), .leave(let eventId):
            let json = ["eventId": eventId]
            return try? JSONSerialization.data(withJSONObject: json, options: [])
        }
    }

    var requestInterceptor: RequestInterceptor? {
        switch self {
        case .myEvents, .join, .leave:
            return AuthenticationInterceptor(authenticator: AccountAuthenticator(),
                                             credential: AccountCredential())
        default: return nil
        }
    }
}
