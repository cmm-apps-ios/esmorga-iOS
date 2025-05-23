//
//  DeepLinkManager.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 19/5/25.
//

import Foundation

class DeepLinkManager: ObservableObject {
    ///Por ahora solo gestiona el de verificationCode. Lo óptimo sería modificarlo a futuro para manejar otras url
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
