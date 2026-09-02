//
//  RemoteEventAttendee.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 02/09/2026.
//

struct RemoteEventAttendee: Codable {
    let name: String
    
    func toDomain() -> EventAttendee {
        return EventAttendee(name: name)
    }
}
