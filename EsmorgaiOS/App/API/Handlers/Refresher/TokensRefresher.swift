//
//  TokensRefresher.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 17/9/24.
//

import Alamofire

protocol TokensRefresher {
    associatedtype Token: Credential
    func refreshTokens(sessionManager: Alamofire.Session, credential: Token, completion: @escaping (_ succeeded: Bool, _ responseCode: Int, _ error: Error?) -> Void)
}
