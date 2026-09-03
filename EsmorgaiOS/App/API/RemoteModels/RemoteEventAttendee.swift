//
//  RemoteEventAttendee.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 02/09/2026.
//

struct RemoteEventAttendee: Codable {
    let totalUsers: Int
    let users: [String]
    
    func toDomain() -> [EventAttendee] {
        return users.map { EventAttendee(name: $0) }
    }
}
