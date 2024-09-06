//
//  UserModelBuilder.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 6/9/24.
//

import Foundation
@testable import EsmorgaiOS

final class UserModelBuilder {

    var name: String = "Ted"
    var lastName: String = "Mosby"
    var email: String = "test@email.com"

    func build() -> UserModels.User {
        return UserModels.User(name: name, lastName: lastName, email: email)
    }
}
