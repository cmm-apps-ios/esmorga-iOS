//
//  NSNotification+Name.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 17/9/24.
//

import Foundation

public extension NSNotification.Name {
    static var forceLogout = NSNotification.Name(rawValue: "Notification.Force.LogOut")
    static var eventUpdated = NSNotification.Name(rawValue: "Notification.Event.Updated")
}
