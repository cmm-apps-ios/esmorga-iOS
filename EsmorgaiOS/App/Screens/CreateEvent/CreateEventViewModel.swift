//
//  CreateEventViewModel.swift
//  EsmorgaiOS
//
//  Created by GitHub Copilot on 21/9/26.
//

import Foundation

enum CreateEventViewState: ViewStateProtocol {
    case ready
}

/// A single ViewModel shared across every step of the create-event flow (Option A).
/// It is created once when the flow starts and kept alive by the coordinator, so
/// navigating back and forward preserves all the state the user has entered.
class CreateEventViewModel: BaseViewModel<CreateEventViewState> {

    // MARK: - Validation constants (mirrors the Flutter cubit)
    private enum Constants {
        static let minimumEventNameLength = 3
        static let maximumEventNameLength = 100
        static let minimumDescriptionLength = 20
        static let maximumDescriptionLength = 5000
        static let maximumLocationLength = 100
        static let minimumMaxCapacity = 1
        static let maximumMaxCapacity = 5000
    }

    private let createEventUseCase: CreateEventUseCaseAlias

    // MARK: - Step 1: Name & description
    @Published var eventName: String = ""
    @Published var eventNameError: String?
    @Published var description: String = ""
    @Published var descriptionError: String?

    // MARK: - Step 2: Type
    @Published var eventType: EventType = .party

    // MARK: - Step 3: Date & join deadline
    @Published var eventDate: Date = Calendar.current.startOfDay(for: Date())
    @Published var eventTime: Date = Date()
    @Published var eventDateError: String?
    @Published var joinDeadlineEnabled: Bool = false
    @Published var joinDeadlineDate: Date = Calendar.current.startOfDay(for: Date())
    @Published var joinDeadlineTime: Date = Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: Date()) ?? Date()
    @Published var joinDeadlineError: String?

    // MARK: - Step 4: Location
    @Published var location: String = ""
    @Published var locationError: String?
    @Published var coordinates: String = ""
    @Published var coordinatesError: String?
    private var parsedLatitude: Double?
    private var parsedLongitude: Double?
    @Published var maxCapacity: String = ""
    @Published var maxCapacityError: String?

    // MARK: - Step 5: Image
    @Published var eventImageUrl: String = ""
    @Published var previewImageUrl: URL?
    @Published var eventImageUrlError: String?

    // MARK: - Submission
    @Published var isSubmitting: Bool = false

    init(coordinator: (any CoordinatorProtocol)?,
         networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared,
         createEventUseCase: CreateEventUseCaseAlias = CreateEventUseCase()) {
        self.createEventUseCase = createEventUseCase
        super.init(coordinator: coordinator, networkMonitor: networkMonitor)
    }

    // MARK: - Step 1 validation
    func validateName() {
        let value = eventName.trimmingCharacters(in: .whitespacesAndNewlines)
        if value.isEmpty {
            eventNameError = LocalizationKeys.TextField.InlineError.emptyField.localize()
        } else if value.count < Constants.minimumEventNameLength || value.count > Constants.maximumEventNameLength {
            eventNameError = LocalizationKeys.CreateEvent.InlineError.invalidLengthName.localize()
        } else {
            eventNameError = nil
        }
    }

    func validateDescription() {
        let value = description.trimmingCharacters(in: .whitespacesAndNewlines)
        if value.isEmpty {
            descriptionError = LocalizationKeys.TextField.InlineError.emptyField.localize()
        } else if value.count < Constants.minimumDescriptionLength || value.count > Constants.maximumDescriptionLength {
            descriptionError = LocalizationKeys.CreateEvent.InlineError.invalidLengthDescription.localize()
        } else {
            descriptionError = nil
        }
    }

    var canProceedFromNameStep: Bool {
        validateNameSilently() && validateDescriptionSilently()
    }

    private func validateNameSilently() -> Bool {
        let value = eventName.trimmingCharacters(in: .whitespacesAndNewlines)
        return !value.isEmpty && value.count >= Constants.minimumEventNameLength && value.count <= Constants.maximumEventNameLength
    }

    private func validateDescriptionSilently() -> Bool {
        let value = description.trimmingCharacters(in: .whitespacesAndNewlines)
        return !value.isEmpty && value.count >= Constants.minimumDescriptionLength && value.count <= Constants.maximumDescriptionLength
    }

    // MARK: - Step 3 validation
    func validateEventDate() {
        eventDateError = validateDateTimeNotInPast(date: eventDate, time: eventTime)
        if joinDeadlineEnabled { revalidateJoinDeadline() }
    }

    private func validateDateTimeNotInPast(date: Date, time: Date) -> String? {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startOfSelected = calendar.startOfDay(for: date)

        if startOfSelected < startOfToday {
            return LocalizationKeys.CreateEvent.InlineError.eventDatePast.localize()
        }
        guard startOfSelected == startOfToday else { return nil }

        if combine(date: date, time: time) < now {
            return LocalizationKeys.CreateEvent.InlineError.eventTimePast.localize()
        }
        return nil
    }

    func toggleJoinDeadline(_ enabled: Bool) {
        joinDeadlineEnabled = enabled
        if enabled {
            joinDeadlineDate = eventDate
            revalidateJoinDeadline()
        } else {
            joinDeadlineError = nil
        }
    }

    func validateJoinDeadline() {
        revalidateJoinDeadline()
    }

    private func revalidateJoinDeadline() {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        if calendar.startOfDay(for: joinDeadlineDate) < startOfToday {
            joinDeadlineError = LocalizationKeys.CreateEvent.InlineError.eventDatePast.localize()
            return
        }
        let deadlineDateTime = combine(date: joinDeadlineDate, time: joinDeadlineTime)
        let eventDateTime = combine(date: eventDate, time: eventTime)
        if deadlineDateTime > eventDateTime {
            joinDeadlineError = LocalizationKeys.CreateEvent.InlineError.joinDeadlineExceeded.localize()
        } else {
            joinDeadlineError = nil
        }
    }

    var canProceedFromDateStep: Bool {
        guard validateDateTimeNotInPast(date: eventDate, time: eventTime) == nil else { return false }
        if joinDeadlineEnabled {
            return joinDeadlineError == nil
        }
        return true
    }

    // MARK: - Step 4 validation
    private static let coordinatesRegex = "^\\s*-?\\d+\\.?\\d*\\s*,\\s*-?\\d+\\.?\\d*\\s*$"

    func validateLocation() {
        let trimmed = location.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            locationError = LocalizationKeys.CreateEvent.InlineError.locationRequired.localize()
        } else {
            locationError = nil
        }
    }

    func validateCoordinates() {
        let value = coordinates.trimmingCharacters(in: .whitespacesAndNewlines)
        parsedLatitude = nil
        parsedLongitude = nil
        guard !value.isEmpty else {
            coordinatesError = nil
            return
        }
        guard value.range(of: Self.coordinatesRegex, options: .regularExpression) != nil else {
            coordinatesError = LocalizationKeys.CreateEvent.InlineError.coordinatesInvalid.localize()
            return
        }
        let parts = value.split(separator: ",")
        guard parts.count >= 2,
              let lat = Double(parts[0].trimmingCharacters(in: .whitespaces)),
              let lng = Double(parts[1].trimmingCharacters(in: .whitespaces)),
              (-90...90).contains(lat), (-180...180).contains(lng) else {
            coordinatesError = LocalizationKeys.CreateEvent.InlineError.coordinatesOutOfBounds.localize()
            return
        }
        parsedLatitude = lat
        parsedLongitude = lng
        coordinatesError = nil
    }

    func validateMaxCapacity() {
        guard !maxCapacity.isEmpty else {
            maxCapacityError = nil
            return
        }
        if let parsed = Int(maxCapacity),
           parsed >= Constants.minimumMaxCapacity,
           parsed <= Constants.maximumMaxCapacity {
            maxCapacityError = nil
        } else {
            maxCapacityError = LocalizationKeys.CreateEvent.InlineError.maxCapacityInvalid.localize()
        }
    }

    var canProceedFromLocationStep: Bool {
        !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        locationError == nil &&
        coordinatesError == nil &&
        maxCapacityError == nil
    }

    // MARK: - Step 5 image
    private static let imageUrlRegex = "^https://.+\\.(jpg|jpeg|png|webp)(\\?.*)?$"

    func previewImage() {
        let trimmed = eventImageUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty,
              trimmed.range(of: Self.imageUrlRegex, options: [.regularExpression, .caseInsensitive]) != nil,
              let url = URL(string: trimmed) else {
            eventImageUrlError = LocalizationKeys.CreateEvent.InlineError.imageUrlRequired.localize()
            previewImageUrl = nil
            return
        }
        eventImageUrlError = nil
        previewImageUrl = url
    }

    func clearImage() {
        eventImageUrl = ""
        previewImageUrl = nil
        eventImageUrlError = nil
    }

    // MARK: - Navigation between steps
    func goToTypeStep() {
        validateName()
        validateDescription()
        guard canProceedFromNameStep else { return }
        coordinator?.push(destination: .createEventType)
    }

    func goToDateStep() {
        coordinator?.push(destination: .createEventDate)
    }

    func goToLocationStep() {
        validateEventDate()
        guard canProceedFromDateStep else { return }
        coordinator?.push(destination: .createEventLocation)
    }

    func goToImageStep() {
        guard canProceedFromLocationStep else { return }
        coordinator?.push(destination: .createEventImage)
    }

    // MARK: - Submit
    @MainActor
    func submit() async {
        guard !isSubmitting else { return }

        guard networkMonitor.isConnected else {
            snackBar = .init(message: LocalizationKeys.Snackbar.noInternet.localize(), isShown: true)
            reportErrorToCrashlytics()
            return
        }

        isSubmitting = true

        let params = CreateEventParams(eventName: eventName.trimmingCharacters(in: .whitespacesAndNewlines),
                                       eventDate: isoString(date: eventDate, time: eventTime),
                                       description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                                       eventType: eventType,
                                       imageUrl: previewImageUrl?.absoluteString,
                                       locationName: location.trimmingCharacters(in: .whitespacesAndNewlines),
                                       locationLat: parsedLatitude,
                                       locationLong: parsedLongitude,
                                       maxCapacity: Int(maxCapacity),
                                       joinDeadline: joinDeadlineEnabled ? isoString(date: joinDeadlineDate, time: joinDeadlineTime) : nil)

        let result = await createEventUseCase.execute(input: params)

        isSubmitting = false

        switch result {
        case .success:
            coordinator?.popToRoot()
        case .failure(let error):
            if case NetworkError.noInternetConnection = error {
                snackBar = .init(message: LocalizationKeys.Snackbar.noInternet.localize(), isShown: true)
                reportErrorToCrashlytics()
            } else {
                showRetryDialog()
            }
        }
    }

    private func showRetryDialog() {
        let dialogModel = ErrorDialogModelBuilder.build(type: .commonError) { [weak self] in
            guard let self else { return }
            Task { await self.submit() }
        }
        coordinator?.push(destination: .dialog(dialogModel))
    }

    // MARK: - Helpers
    private func combine(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let day = calendar.dateComponents([.year, .month, .day], from: date)
        let clock = calendar.dateComponents([.hour, .minute], from: time)
        var merged = DateComponents()
        merged.year = day.year
        merged.month = day.month
        merged.day = day.day
        merged.hour = clock.hour
        merged.minute = clock.minute
        return calendar.date(from: merged) ?? date
    }

    private func isoString(date: Date, time: Date) -> String {
        let combined = combine(date: date, time: time)
        let formatter = DateFormatter()
        // The backend expects a literal "Z" (Zulu/UTC) suffix, e.g. 2026-09-21T23:59:00.000Z.
        // Using "Z" in the pattern would emit "+0000", so we force UTC and append a literal 'Z'.
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: combined)
    }
}
