//
//  RemotePoll.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 21/09/2026.
//

import Foundation

struct RemotePoll: Codable {
    let pollId: String?
    let pollName: String?
    let description: String?
    let options: [RemotePollOption]?
    let voteDeadline: String?
    let isMultipleChoice: Bool?
    let userSelectedOptions: [String]?
}

extension RemotePoll {
    func toDomain() -> Poll {
        Poll(
            id: self.pollId ?? "",
            name: self.pollName ?? "",
            description: self.description ?? "",
            options: self.options?.map { $0.toDomain() } ?? [],
            voteDeadline: self.voteDeadline?.date(format: .iso8601) ?? Date(),
            isMultipleChoice: self.isMultipleChoice ?? false,
            userSelectedOptions: self.userSelectedOptions ?? []
        )
    }
}
