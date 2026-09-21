//
//  RemotePoll.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 21/09/2026.
//

import Foundation

struct Poll {
    let pollId: String
    let pollName: String
    let description: String
    let options: [PollOption]
    let voteDeadline: String
    let isMultipleChoice: Bool
    let userSelectedOptions: [String]
}
