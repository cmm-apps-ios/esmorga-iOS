//
//  ProfileScreenSnapshotTests.swift
//  EsmorgaiOSSnapshotTests
//
//  Created by Ares Armesto, Yago on 12/3/25.
//

import XCTest
import SnapshotTesting
@testable import EsmorgaiOS

final class ProfileScreenSnapshotTests: XCTestCase {
    
    private var sut: ProfileView!
    private var viewModel: ProfileViewModel!
    private var mockGetLocalUserUseCase: MockGetLocalUserUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
        mockGetLocalUserUseCase = nil
        try super.tearDownWithError()
    }
    
    @MainActor
    func test_given_profile_view_screen_when_user_is_not_logged_then_content_view_is_correct() async throws {
        giveSut(user: nil)
        await TestHelper.fullfillTask {
            await self.viewModel.checkLoginStatus()
        }
        assertSnapshot(of: sut.toVC(), as: .image)
    }
    
    @MainActor
     func test_given_profile_view_when_user_is_logged_then_content_view_is_correct() async throws {
         giveSut(user: UserModels.User(name: "Yago", lastName: "Ares", email: "yagoares@example.com"))
         await TestHelper.fullfillTask {
             await self.viewModel.checkLoginStatus()
         }
         assertSnapshot(of: sut.toVC(), as: .image)
     }
    
    
    private func giveSut(user: UserModels.User?) {
        mockGetLocalUserUseCase = MockGetLocalUserUseCase()
        mockGetLocalUserUseCase.mockUser = user
        viewModel = ProfileViewModel(coordinator: nil,
                                     getLocalUserUseCase: mockGetLocalUserUseCase)
        sut = ProfileView(viewModel: viewModel)
    }
}
