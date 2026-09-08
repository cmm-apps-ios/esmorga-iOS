//
//  AccountLoginModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 20/8/24.
//

import Foundation

class AccountLoginModel {

    struct Login: Codable {
        let accessToken: String
        let refreshToken: String
        let ttl: Int
        let profile: Profile
    }

    struct Profile: Codable {
        let name: String
        let lastName: String
        let email: String
        let role: String

        func toDomain() -> UserModels.User {
            return UserModels.User(name: name,
                                   lastName: lastName,
                                   email: email, role: UserModels.RoleType(rawValue: role.lowercased()) ?? .user)
        }
    }
}
