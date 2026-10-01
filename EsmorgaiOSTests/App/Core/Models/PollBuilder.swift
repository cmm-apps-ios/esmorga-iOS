//
//  PollBuilder.swift
//  EsmorgaiOS
//
//  Created by Marcelo Moran on 29/9/26.
//

import Foundation
@testable import EsmorgaiOS

final class PollBuilder {

    private var id: String = "1234"
    private var name: String = "Poll name"
    private var description: String = "Poll description"
    private var options: [PollOption] = [
        PollOption(id: "opt1", name: "Option 1", voteCount: 1),
        PollOption(id: "opt2", name: "Option 2", voteCount: 0)
    ]
    private var voteDeadline: Date = Calendar.current.date(
        from: DateComponents(
            year: 2028,
            month: 12,
            day: 31,
            hour: 23,
            minute: 59
        ))!
    
    private var isMultipleChoice: Bool = false
    private var userSelectedOptions: [String] = []

    func with(id: String) -> Self {
        self.id = id
        return self
    }

    func with(name: String) -> Self {
        self.name = name
        return self
    }

    func with(description: String) -> Self {
        self.description = description
        return self
    }

    func with(options: [PollOption]) -> Self {
        self.options = options
        return self
    }

    func with(voteDeadline: Date) -> Self {
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

    func build() -> Poll {
        return Poll(id: id,
                    name: name,
                    description: description,
                    options: options,
                    voteDeadline: voteDeadline,
                    isMultipleChoice: isMultipleChoice,
                    userSelectedOptions: userSelectedOptions)
    }
}
