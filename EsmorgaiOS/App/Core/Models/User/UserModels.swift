//
//  UserModels.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 20/8/24.
//

import Foundation

enum UserModels {
    
    enum RoleType: String {
      case user
      case admin
    }

    struct User: DataConvertible, Equatable {
        let name: String
        let lastName: String
        let email: String
        let role: RoleType
        
        typealias NSManagedObject = MOUser

        @discardableResult
        func convert(to coreData: MOUser) -> MOUser? {
            let managedObject = coreData
            managedObject.name = name
            managedObject.lastName = lastName
            managedObject.email = email
            managedObject.role = role.rawValue
            return managedObject
        }

        static func convert(from managedObject: MOUser) -> UserModels.User? {

            return UserModels.User(name: managedObject.name ?? "",
                                   lastName: managedObject.lastName ?? "",
                                   email: managedObject.email ?? "",
                                   role: RoleType(rawValue: managedObject.role ?? "") ?? .user)
        }
    }
}
