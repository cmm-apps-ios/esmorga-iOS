//
//  CreateEventRequestModel.swift
//  EsmorgaiOS
//
//  Created by GitHub Copilot on 21/9/26.
//

import Foundation

/// Request body sent to `POST /v1/events`.
/// Optional properties are automatically omitted from the JSON when `nil`.
struct CreateEventRequestModel: Encodable {

    let eventName: String
    let eventDate: String
    let description: String
    let eventType: String
    let imageUrl: String?
    let location: Location
    let maxCapacity: Int?
    let joinDeadline: String?

    struct Location: Encodable {
        let name: String
        let lat: Double?
        let long: Double?
    }

    init(params: CreateEventParams) {
        self.eventName = params.eventName
        self.eventDate = params.eventDate
        self.description = params.description
        self.eventType = params.eventType.apiValue
        self.imageUrl = params.imageUrl
        self.location = Location(name: params.locationName,
                                 lat: params.locationLat,
                                 long: params.locationLong)
        self.maxCapacity = params.maxCapacity
        self.joinDeadline = params.joinDeadline
    }

    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
