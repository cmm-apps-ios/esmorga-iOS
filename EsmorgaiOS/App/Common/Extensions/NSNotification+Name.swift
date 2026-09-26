//
//  NSNotification+Name.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 17/9/24.
//

import Foundation

public extension NSNotification.Name {
    static var forceLogout = NSNotification.Name(rawValue: "Notification.Force.LogOut")
    static var pollUpdated = NSNotification.Name(rawValue: "Notification.Poll.Updated")
}
