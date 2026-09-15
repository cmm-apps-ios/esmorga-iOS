//
//  EventAttendee.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 02/09/2026.
//

import Foundation
import CoreData

struct EventAttendee: Identifiable, DataConvertible {
    typealias ManagedObject = MOEventAttendee
    
    let id: UUID
    let name: String
    var hasPayed: Bool
    
    init(id: UUID = UUID(), name: String, hasPayed: Bool) {
        self.id = id
        self.name = name
        self.hasPayed = hasPayed
    }
    
    @discardableResult
    func convert(to coreData: MOEventAttendee) -> MOEventAttendee? {
        let managedObject = coreData
        managedObject.name = name
        managedObject.id = id
        managedObject.hasPayed = hasPayed
        return managedObject
    }

    static func convert(from managedObject: MOEventAttendee) -> EventAttendee? {

        return EventAttendee(id: managedObject.id ?? UUID(),
                             name: managedObject.name ?? "",
                             hasPayed: managedObject.hasPayed
        )
    }
}
