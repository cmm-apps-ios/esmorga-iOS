//
//  DeepLinkManager.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 19/5/25.
//

import Foundation

enum DeepLinkType :Equatable {
    case verification(code: String)
    case resetPassword(code: String)
    case unknown
}

class DeepLinkManager: ObservableObject {
    @Published var deepLink: DeepLinkType?

    func handle(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            deepLink = .unknown
            print("Deep link no reconocido: \(url)")
            return
        }

        if let code = components.queryItems?.first(where: { $0.name == "verificationCode" })?.value {
            deepLink = .verification(code: code)
            print("Deep link: verification, code: \(code)")
        } else if let code = components.queryItems?.first(where: { $0.name == "forgotPasswordCode" })?.value {
            deepLink = .resetPassword(code: code)
            print("Deep link: invite, token: \(code)")
        } else {
            deepLink = .unknown
            print("Deep link no reconocido: \(url)")
        }
    }
}
