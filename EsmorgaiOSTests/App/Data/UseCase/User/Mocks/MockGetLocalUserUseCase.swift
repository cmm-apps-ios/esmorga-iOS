//
//  MockGetLocalUserUseCase.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 6/9/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockGetLocalUserUseCase: GetLocalUserUseCaseAlias {

    var mockUser: UserModels.User?

    override func job() async -> GetLocalUserResult {
        guard let mockUser else {
            return .failure(.noCacheContent)
        }
        return .success(mockUser)
    }
}
