//
//  RemotePollOption.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 21/09/2026.
//

import Foundation

struct RemotePollOption: Codable {
    let optionId: String?
    let option: String?
    let voteCount: Int?
}

extension RemotePollOption {
    func toDomain() -> PollOption {
        PollOption(
            optionId: self.optionId ?? "",
            option: self.option ?? "",
            voteCount: self.voteCount ?? 0
        )
    }
}
