//
//  RemotePollBuilder.swift
//  EsmorgaiOS
//
//  Created by Marcelo Moran on 29/9/26.
//

import Foundation
@testable import EsmorgaiOS

final class RemotePollBuilder {

    private var pollId: String = "1234"
    private var pollName: String = "Poll name"
    private var description: String = "Poll description"
    private var options: [RemotePollOption] = [
        RemotePollOption(optionId: "opt1", option: "Option 1", voteCount: 1),
        RemotePollOption(optionId: "opt2", option: "Option 2", voteCount: 0)
    ]
    private var voteDeadline: String = "2026-10-31T23:59:59.000Z"
    private var isMultipleChoice: Bool = false
    private var userSelectedOptions: [String] = []

    func with(pollId: String) -> Self {
        self.pollId = pollId
        return self
    }

    func with(pollName: String) -> Self {
        self.pollName = pollName
        return self
    }

    func with(description: String) -> Self {
        self.description = description
        return self
    }

    func with(options: [RemotePollOption]) -> Self {
        self.options = options
        return self
    }

    func with(voteDeadline: String) -> Self {
        self.voteDeadline = voteDeadline
        return self
    }

    func with(isMultipleChoice: Bool) -> Self {
        self.isMultipleChoice = isMultipleChoice
        return self
    }

    func with(userSelectedOptions: [String]) -> Self {
        self.userSelectedOptions = userSelectedOptions
        return self
    }

    func build() -> RemotePoll {
        return RemotePoll(pollId: pollId,
                          pollName: pollName,
                          description: description,
                          options: options,
                          voteDeadline: voteDeadline,
                          isMultipleChoice: isMultipleChoice,
                          userSelectedOptions: userSelectedOptions)
    }

    func buildListResponse(totalPolls: Int? = nil) -> RemotePollList {
        return RemotePollList(totalPolls: totalPolls, polls: [build()])
    }
}
