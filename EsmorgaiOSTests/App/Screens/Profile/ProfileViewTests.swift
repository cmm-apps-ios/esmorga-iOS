import XCTest
import ViewInspector
import SwiftUI
@testable import EsmorgaiOS

final class ProfileViewTests: XCTestCase {

    private var sut: ProfileView!
    private var viewModel: ProfileViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = ProfileViewModel(coordinator: SpyCoordinator())
        sut = ProfileView(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_profile_view_when_state_is_ready_then_show_profile_view() throws {
        viewModel.state = .ready
        let inspected = try sut.inspect()
        
        XCTAssertNoThrow(try inspected.find(viewWithAccessibilityIdentifier: ProfileView.AccessibilityIds.profileView))
        
        let title = try inspected.find(viewWithAccessibilityIdentifier: ProfileView.AccessibilityIds.title).text().string()
        XCTAssertEqual(title, LocalizationKeys.Profile.title.localize())
        
    }

    func test_given_profile_view_when_state_is_logged_out_then_show_error_view() throws {
        viewModel.state = .loggedOut
        let inspected = try sut.inspect()

        XCTAssertNoThrow(try inspected.find(viewWithAccessibilityIdentifier: ProfileView.AccessibilityIds.errorView))
    
    }
}
