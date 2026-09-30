//
//  CreateEventViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by GitHub Copilot on 25/9/26.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class CreateEventViewModelTests {

    private var sut: CreateEventViewModel!
    private var mockCreateEventUseCase: MockCreateEventUseCase!
    private var mockNetworkMonitor: MockNetworkMonitor!
    private var spyCoordinator: SpyCoordinator!

    init() {
        mockCreateEventUseCase = MockCreateEventUseCase()
        mockNetworkMonitor = MockNetworkMonitor()
        spyCoordinator = SpyCoordinator()
        sut = CreateEventViewModel(coordinator: spyCoordinator,
                                   networkMonitor: mockNetworkMonitor,
                                   createEventUseCase: mockCreateEventUseCase)
    }

    deinit {
        mockCreateEventUseCase = nil
        mockNetworkMonitor = nil
        spyCoordinator = nil
        sut = nil
    }

    // MARK: - Step 1: Name & description validation

    @Test
    func test_given_empty_name_when_validate_then_empty_field_error_is_shown() {

        sut.eventName = ""

        sut.validateName()

        #expect(self.sut.eventNameError == LocalizationKeys.TextField.InlineError.emptyField.localize())
    }

    @Test
    func test_given_short_name_when_validate_then_invalid_length_error_is_shown() {

        sut.eventName = "AB"

        sut.validateName()

        #expect(self.sut.eventNameError == LocalizationKeys.CreateEvent.InlineError.invalidLengthName.localize())
    }

    @Test
    func test_given_valid_name_when_validate_then_no_error() {

        sut.eventName = "Valid event name"

        sut.validateName()

        #expect(self.sut.eventNameError == nil)
    }

    @Test
    func test_given_short_description_when_validate_then_invalid_length_error_is_shown() {

        sut.description = "Too short"

        sut.validateDescription()

        #expect(self.sut.descriptionError == LocalizationKeys.CreateEvent.InlineError.invalidLengthDescription.localize())
    }

    @Test
    func test_given_valid_name_and_description_when_check_then_can_proceed_is_true() {

        sut.eventName = "Valid event name"
        sut.description = "This is a valid long enough description"

        #expect(self.sut.canProceedFromNameStep == true)
    }

    @Test
    func test_given_invalid_form_when_go_to_type_step_then_does_not_navigate() {

        sut.eventName = "AB"
        sut.description = "short"

        sut.goToTypeStep()

        #expect(self.spyCoordinator.pushCalled == false)
    }

    @Test
    func test_given_valid_form_when_go_to_type_step_then_navigates_to_type() {

        sut.eventName = "Valid event name"
        sut.description = "This is a valid long enough description"

        sut.goToTypeStep()

        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .createEventType)
    }

    // MARK: - Step 2: Type

    @Test
    func test_given_default_state_then_event_type_is_party() {

        #expect(self.sut.eventType == .party)
    }

    @Test
    func test_given_type_step_when_go_to_date_step_then_navigates_to_date() {

        sut.goToDateStep()

        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .createEventDate)
    }

    // MARK: - Step 3: Date

    @Test
    func test_given_past_date_when_validate_then_date_past_error_is_shown() {

        sut.eventDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!

        sut.validateEventDate()

        #expect(self.sut.eventDateError == LocalizationKeys.CreateEvent.InlineError.eventDatePast.localize())
    }

    @Test
    func test_given_future_date_when_go_to_location_step_then_navigates_to_location() {

        sut.eventDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())!

        sut.goToLocationStep()

        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .createEventLocation)
    }

    @Test
    func test_given_enabled_join_deadline_after_event_when_validate_then_exceeded_error_is_shown() {

        sut.eventDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        sut.toggleJoinDeadline(true)
        sut.joinDeadlineDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())!

        sut.validateJoinDeadline()

        #expect(self.sut.joinDeadlineError == LocalizationKeys.CreateEvent.InlineError.joinDeadlineExceeded.localize())
    }

    // MARK: - Step 4: Location

    @Test
    func test_given_empty_location_when_validate_then_required_error_is_shown() {

        sut.location = ""

        sut.validateLocation()

        #expect(self.sut.locationError == LocalizationKeys.CreateEvent.InlineError.locationRequired.localize())
    }

    @Test
    func test_given_invalid_coordinates_when_validate_then_invalid_error_is_shown() {

        sut.coordinates = "not-coordinates"

        sut.validateCoordinates()

        #expect(self.sut.coordinatesError == LocalizationKeys.CreateEvent.InlineError.coordinatesInvalid.localize())
    }

    @Test
    func test_given_out_of_bounds_coordinates_when_validate_then_out_of_bounds_error_is_shown() {

        sut.coordinates = "200, 200"

        sut.validateCoordinates()

        #expect(self.sut.coordinatesError == LocalizationKeys.CreateEvent.InlineError.coordinatesOutOfBounds.localize())
    }

    @Test
    func test_given_valid_coordinates_when_validate_then_no_error() {

        sut.coordinates = "43.3623, -8.4115"

        sut.validateCoordinates()

        #expect(self.sut.coordinatesError == nil)
    }

    @Test
    func test_given_invalid_max_capacity_when_validate_then_error_is_shown() {

        sut.maxCapacity = "99999"

        sut.validateMaxCapacity()

        #expect(self.sut.maxCapacityError == LocalizationKeys.CreateEvent.InlineError.maxCapacityInvalid.localize())
    }

    @Test
    func test_given_valid_location_when_go_to_image_step_then_navigates_to_image() {

        sut.location = "A Coruña"

        sut.goToImageStep()

        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .createEventImage)
    }

    // MARK: - Step 5: Image

    @Test
    func test_given_invalid_image_url_when_preview_then_error_is_shown() {

        sut.eventImageUrl = "http://invalid"

        sut.previewImage()

        #expect(self.sut.eventImageUrlError == LocalizationKeys.CreateEvent.InlineError.imageUrlRequired.localize())
        #expect(self.sut.previewImageUrl == nil)
    }

    @Test
    func test_given_valid_image_url_when_preview_then_preview_is_set() {

        sut.eventImageUrl = "https://example.com/image.png"

        sut.previewImage()

        #expect(self.sut.eventImageUrlError == nil)
        #expect(self.sut.previewImageUrl == URL(string: "https://example.com/image.png"))
    }

    // MARK: - Submit

    @MainActor
    @Test
    func test_given_submit_when_success_then_use_case_is_called_and_pop_to_root() async {

        sut.eventName = "  Valid event name  "
        sut.description = "This is a valid long enough description"
        sut.eventType = .sport
        sut.location = "A Coruña"
        mockCreateEventUseCase.mockResult = .success(())

        await TestHelper.fullfillTask {
            await self.sut.submit()
        }

        #expect(self.mockCreateEventUseCase.executeCalled == true)
        #expect(self.mockCreateEventUseCase.receivedParams?.eventName == "Valid event name")
        #expect(self.mockCreateEventUseCase.receivedParams?.eventType == .sport)
        #expect(self.mockCreateEventUseCase.receivedParams?.locationName == "A Coruña")
        #expect(self.sut.isSubmitting == false)
        #expect(self.spyCoordinator.popToRootCalled == true)
    }

    @MainActor
    @Test
    func test_given_submit_when_no_internet_then_snackbar_is_shown_and_use_case_not_called() async {

        mockNetworkMonitor.mockIsConnected = false

        await TestHelper.fullfillTask {
            await self.sut.submit()
        }

        #expect(self.mockCreateEventUseCase.executeCalled == false)
        #expect(self.sut.snackBar.isShown == true)
        #expect(self.spyCoordinator.popToRootCalled == false)
    }

    @MainActor
    @Test
    func test_given_submit_when_generic_error_then_error_dialog_is_shown() async {

        mockCreateEventUseCase.mockResult = .failure(NetworkError.generalError(code: 500))

        await TestHelper.fullfillTask {
            await self.sut.submit()
        }

        #expect(self.sut.isSubmitting == false)
        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .dialog(ErrorDialogModelBuilder.build(type: .commonError)))
    }

    @MainActor
    @Test
    func test_given_submit_when_no_internet_error_from_use_case_then_snackbar_is_shown() async {

        mockCreateEventUseCase.mockResult = .failure(NetworkError.noInternetConnection)

        await TestHelper.fullfillTask {
            await self.sut.submit()
        }

        #expect(self.sut.snackBar.isShown == true)
        #expect(self.spyCoordinator.popToRootCalled == false)
    }
}
