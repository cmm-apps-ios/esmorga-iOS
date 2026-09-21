//
//  PollResponse.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 21/09/2026.
//

import Foundation

struct RemotePollList: Codable {
    let totalPolls: Int?
    let polls: [RemotePoll]?
}
