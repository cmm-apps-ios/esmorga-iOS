//
//  Credential.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 17/9/24.
//

import Alamofire

protocol Credential: AuthenticationCredential {
    associatedtype Token: Codable
    var accessToken: String? { get }
    var refreshToken: String? { get }
    func store(tokens: Token) throws
}
