//
//  EventAttendeesViewModelTests.swift
//  EsmorgaiOSTests
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class EventAttendeesViewModelTests {

    private var sut: EventAttendeesViewModel!
    private var spyCoordinator: SpyCoordinator!
    private var mockGetEventAttendeesUseCase: MockGetEventAttendeesUseCase!
    private var mockSaveEventAttendeesUseCase: MockSaveEventAttendeesUseCase!

    init() {
        spyCoordinator = SpyCoordinator()
        mockGetEventAttendeesUseCase = MockGetEventAttendeesUseCase()
        mockSaveEventAttendeesUseCase = MockSaveEventAttendeesUseCase()
    }

    deinit {
        spyCoordinator = nil
        mockGetEventAttendeesUseCase = nil
        mockSaveEventAttendeesUseCase = nil
        sut = nil
    }

    @MainActor
    @Test
    func test_given_get_event_attendees_when_success_then_attendees_are_set() async {
        let attendees = [EventAttendee(name: "Alice", hasPayed: false),
                         EventAttendee(name: "Bob", hasPayed: true)]
        mockGetEventAttendeesUseCase.mockAttendees = attendees
        giveSut()

        await TestHelper.fullfillTask {
            await self.sut.getEventAttendees()
        }

        #expect(self.sut.attendees.count == 2)
        #expect(self.sut.attendees.map(\.name) == ["Alice", "Bob"])
        #expect(self.sut.attendees.map(\.hasPayed) == [false, true])
    }

    @MainActor
    @Test
    func test_given_get_event_attendees_when_no_attendees_then_attendees_are_empty() async {
        mockGetEventAttendeesUseCase.mockAttendees = []
        giveSut()

        await TestHelper.fullfillTask {
            await self.sut.getEventAttendees()
        }

        #expect(self.sut.attendees.isEmpty)
    }

    @MainActor
    @Test
    func test_given_update_attendee_payed_when_called_then_save_use_case_receives_current_attendees() async {
        let attendees = [EventAttendee(name: "Alice", hasPayed: false)]
        mockGetEventAttendeesUseCase.mockAttendees = attendees
        giveSut()

        await TestHelper.fullfillTask {
            await self.sut.getEventAttendees()
        }

        sut.attendees[0].hasPayed = true
        await TestHelper.fullfillTask {
            await self.sut.updateAttendeeHasPayed()
        }

        #expect(self.mockSaveEventAttendeesUseCase.savedAttendees?.first?.hasPayed == true)
    }

    private func giveSut() {
        sut = EventAttendeesViewModel(coordinator: spyCoordinator,
                                      getEventAttendeesUseCase: mockGetEventAttendeesUseCase,
                                      saveEventAttendeesUseCase: mockSaveEventAttendeesUseCase,
                                      eventId: "1234")
    }
}
