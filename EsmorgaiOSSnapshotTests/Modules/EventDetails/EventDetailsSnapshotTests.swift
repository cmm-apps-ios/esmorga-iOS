//
//  EventDetailsSnapshotTests.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/10/24.
//

import XCTest
import SnapshotTesting
@testable import EsmorgaiOS

final class EventDetailsSnapshotTests: XCTestCase {

    private var sut: EventDetailsView!
    private var viewModel: EventDetailsViewModel!
    private var mockGetLocalUserUseCase: MockGetLocalUserUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        NSTimeZone.default = TimeZone(identifier: "Europe/Madrid")!
    }

    override func tearDownWithError() throws {
        NSTimeZone.resetSystemTimeZone()
        sut = nil
        viewModel = nil
        mockGetLocalUserUseCase = nil
        try super.tearDownWithError()
    }

    //MOB-TC-7
    @MainActor
    func test_given_event_details_view_when_user_is_not_logged_then_content_view_is_correct() async throws {
        giveSut(event: EventBuilder().build())
        await TestHelper.fullfillTask {
            await self.viewModel.viewLoad()
        }
        assertSnapshot(of: sut.toVC(), as: .image)
    }

    //MOB-TC-184
    @MainActor
    func test_given_event_details_view_when_user_is_logged_and_not_joined_to_the_event_then_content_view_is_correct() async throws {
        giveSut(event: EventBuilder().build())
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()
        await TestHelper.fullfillTask {
            await self.viewModel.viewLoad()
        }
        assertSnapshot(of: sut.toVC(), as: .image)
    }

    //MOB-TC-202
    @MainActor
    func test_given_event_details_view_when_user_is_logged_and_joined_to_the_event_then_content_view_is_correct() async throws {
        giveSut(event: EventBuilder().with(isUserJoined: true).build())
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()
        await TestHelper.fullfillTask {
            await self.viewModel.viewLoad()
        }
        assertSnapshot(of: sut.toVC(), as: .image)
    }

    private func giveSut(event: EventModels.Event) {
        mockGetLocalUserUseCase = MockGetLocalUserUseCase()
        viewModel = EventDetailsViewModel(coordinator: nil,
                                          event: event,
                                          getLocalUserUseCase: mockGetLocalUserUseCase)
        sut = EventDetailsView(viewModel: viewModel)
    }
}
