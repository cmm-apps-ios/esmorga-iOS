//
//  MockSendVotePollUseCase.swift
//  EsmorgaiOS
//
//  Created by Marcelo Moran on 29/9/26.
//

import Foundation
@testable import EsmorgaiOS

final class MockSendVotePollUseCase: SendVotePollUseCaseAlias {

    var mockVotedPoll: Poll?

    override func job(input: VotePollRequest) async -> SendVotePollUseCaseResult {
        guard let mockVotedPoll else {
            return .failure(NetworkError.generalError(code: 500))
        }
        return .success(mockVotedPoll)
    }
}
