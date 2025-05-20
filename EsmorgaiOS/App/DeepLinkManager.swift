//
//  DeepLinkManager.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 19/5/25.
//

import Foundation

class DeepLinkManager: ObservableObject {
    @Published var verificationCode: String? = nil

    func handle(url: URL) {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let code = components.queryItems?.first(where: { $0.name == "verificationCode" })?.value {
            self.verificationCode = code
            print("Código se envía: \(code)")
           } else {
               print("Deep link no reconocido: \(url)")
           }
    }
}
