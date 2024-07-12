//
//  CoreDataConvertible.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 10/7/24.
//

import CoreData

typealias DataConvertible = CoreDataConvertible & DomainDataConvertible

protocol CoreDataConvertible {
    associatedtype ManagedObject: NSManagedObject

    func convert(in context: NSManagedObjectContext) -> ManagedObject?
    func convert(to base: ManagedObject) -> ManagedObject?
}

extension CoreDataConvertible {

    @discardableResult
    func convert(in context: NSManagedObjectContext) -> ManagedObject? {
        guard let mO = NSEntityDescription.insertNewObject(forEntityName: ManagedObject.entityName, into: context) as? ManagedObject else { return nil }
        return convert(to: mO)
    }
}

protocol DomainDataConvertible {
    associatedtype ManagedObject: NSManagedObject

    static func convert(from managedObject: ManagedObject) -> Self?
}
