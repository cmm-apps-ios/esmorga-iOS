//
//  LocalUserDataSource.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 6/9/24.
//

import Foundation
import CoreData

protocol LocalUserDataSourceProtocol {
    func saveUser(_ user: UserModels.User) async throws -> ()
    func getUser() async -> UserModels.User?
    func clearAll()
}

class LocalUserDataSource: LocalUserDataSourceProtocol {

    let container: NSPersistentContainer

    init(container: NSPersistentContainer = NSPersistentContainer(name: "Esmorga")) {
        self.container = container
        self.container.loadPersistentStores { description, error in
            if error != nil {
                fatalError("Cannot Load Core Data Model")
            }
        }
    }

    func saveUser(_ user: UserModels.User) async throws -> () {
        clearAll()
        user.convert(in: container.viewContext)
        try? container.viewContext.save()
        return ()
    }

    func getUser() async -> UserModels.User? {
        let request = NSFetchRequest<MOUser>(entityName: "MOUser")
        do {
            if let user = try container.viewContext.fetch(request).first {
                return UserModels.User.convert(from: user)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    func clearAll() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MOUser")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try container.viewContext.execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
}
