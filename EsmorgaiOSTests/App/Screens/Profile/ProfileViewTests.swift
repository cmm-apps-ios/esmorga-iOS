import XCTest
import ViewInspector
import SwiftUI
@testable import EsmorgaiOS

final class ProfileViewTests: XCTestCase {
    
    private var sut: ProfileView!
    private var viewModel: ProfileViewModel!
    private var profileModel: ProfileModels!
    
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
        
        if let model = viewModel.loggedModel {
            for item in model.userSection.items {
                let itemTitle = try inspected.find(viewWithAccessibilityIdentifier: ProfileView.AccessibilityIds.rowDataTitle + "Title" + "\(item.id)").text().string()
                let itemValue = try inspected.find(viewWithAccessibilityIdentifier: ProfileView.AccessibilityIds.rowDataTitle + "Value" + "\(item.id)").text().string()
                XCTAssertEqual(itemTitle, item.title)
                XCTAssertEqual(itemValue, item.value)
            }
            
            let optionsTitle = try inspected.find(viewWithAccessibilityIdentifier: ProfileView.AccessibilityIds.rowOptionTitle).text().string()
            XCTAssertEqual(optionsTitle, model.optionsSection.title)
            
            for item in model.optionsSection.items {
                let optionTitleSecondary = try inspected.find(viewWithAccessibilityIdentifier: ProfileView.AccessibilityIds.rowOptionTitleSecondary + "TitleSecondary" + "\(item.id)").text().string()
                
                let optionImage = try inspected.find(viewWithAccessibilityIdentifier: ProfileView.AccessibilityIds.rowOptionImage + "Image" + "\(item.id)").text().string()
                XCTAssertEqual(optionTitleSecondary, item.title)
                XCTAssertEqual(optionImage, item.image)
            }
        }
    }
}
