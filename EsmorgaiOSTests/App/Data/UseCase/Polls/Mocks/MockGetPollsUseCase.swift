//
//  MockGetPollsUseCase.swift
//  EsmorgaiOS
//
//  Created by Marcelo Moran on 29/9/26.
//

import Foundation
@testable import EsmorgaiOS

final class MockGetPollsUseCase: GetPollsUseCaseAlias {

    var mockPolls: [Poll]?

    override func job() async -> GetPollsUseCaseResult {
        guard let mockPolls else {
            return .failure(NetworkError.generalError(code: 500))
        }
        return .success(mockPolls)
    }
}
