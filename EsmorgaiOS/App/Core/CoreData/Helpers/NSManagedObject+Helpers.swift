//
//  NSManagedObject+Helpers.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 10/7/24.
//

import CoreData

extension NSManagedObject {
    static var entityName: String { return String(describing: self) }
}
