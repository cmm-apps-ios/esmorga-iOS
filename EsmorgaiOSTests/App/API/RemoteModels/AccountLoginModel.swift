//
//  AccountLoginModel.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 26/8/24.
//

import Foundation
@testable import EsmorgaiOS

final class LoginModelBuilder {

    func build() -> AccountLoginModel.Login {
        return AccountLoginModel.Login(accessToken: "accessToken",
                                       refreshToken: "refreshToken",
                                       ttl: 60,
                                       profile: AccountLoginModel.Profile(name: "user",
                                                                          lastName: "fake",
                                                                          email: "email@yopmail.com"))
    }
}
