//
//  GetEventListUseCaseTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 30/7/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class GetEventListUseCaseTests: XCTestCase {

    private var sut: GetEventListUseCase!
    private var mockEventsRepository: MockEventsRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockEventsRepository = MockEventsRepository()
        sut = GetEventListUseCase(eventsRepsitory: mockEventsRepository)
    }

    override func tearDownWithError() throws {
        mockEventsRepository = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_get_event_list_when_success_result_then_return_correct_events() async {
        let mockResult = ([EventBuilder().build()], false)
        mockEventsRepository.mockResult = mockResult

        let result = await self.sut.getEventList(forceRefresh: true)
        switch result {
        case .success(let data):
            expect(data).to(equal(mockResult))
            expect(self.mockEventsRepository.refreshValue).to(beTrue())
        case .failure(let error):
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_given_get_event_list_when_failure_result_then_return_correct_error() async {

        let result = await self.sut.getEventList(forceRefresh: true)
        switch result {
        case .success:
            XCTFail("Unexpected error: Success Result")
        case .failure(let error):
            expect(error).to(matchError(NetworkError.genaralError(code: 500)))
        }
    }
}

final class EventBuilder {

    private var eventId: String = "1234"
    private var name: String = "Event Name"
    private var date: Date = Date(timeIntervalSince1970: 10000)
    private var details: String = "Event Details"
    private var eventType: String = "ONLINE"
    private var imageURL: URL?
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    private var location: String = "A Coruña"
    private var creationDate: Date = Date(timeIntervalSince1970: 10000)

    func with(eventId: String) -> Self {
        self.eventId = eventId
        return self
    }

    func with(name: String) -> Self {
        self.name = name
        return self
    }

    func with(date: Date) -> Self {
        self.date = date
        return self
    }

    func with(details: String) -> Self {
        self.details = details
        return self
    }

    func with(eventType: String) -> Self {
        self.eventType = eventType
        return self
    }

    func with(imageURL: URL) -> Self {
        self.imageURL = imageURL
        return self
    }

    func with(latitude: Double) -> Self {
        self.latitude = latitude
        return self
    }

    func with(longitude: Double) -> Self {
        self.longitude = longitude
        return self
    }

    func with(location: String) -> Self {
        self.location = location
        return self
    }

    func with(creationDate: Date) -> Self {
        self.creationDate = creationDate
        return self
    }

    func build() -> EventModels.Event {
        return EventModels.Event(eventId: eventId,
                                 name: name,
                                 date: date,
                                 details: details,
                                 eventType: eventType,
                                 imageURL: imageURL,
                                 latitude: latitude,
                                 longitude: longitude,
                                 location: location,
                                 creationDate: creationDate)
    }
}
