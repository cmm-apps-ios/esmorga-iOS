//
//  RemotePoll.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 21/09/2026.
//

import Foundation

struct Poll: Hashable {
    let id: String
    let name: String
    let description: String
    let options: [PollOption]
    let voteDeadline: Date
    let isMultipleChoice: Bool
    let userSelectedOptions: [String]
}
