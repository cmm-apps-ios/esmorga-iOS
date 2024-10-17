//
//  EventDetailsMapper.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/10/24.
//

final class EventDetailsMapper {

    static func mapEventDetails(_ event: EventModels.Event, isUserLogged: Bool) -> EventDetails.Model {

        var primaryButtonText: String {

            guard isUserLogged else {
                return LocalizationKeys.Buttons.loginToJoin.localize()
            }
            if event.isUserJoined {
                return LocalizationKeys.Buttons.leaveEvent.localize()
            } else {
                return LocalizationKeys.Buttons.joinEvent.localize()
            }
        }

        return EventDetails.Model(imageUrl: event.imageURL,
                                  title: event.name,
                                  body: event.date.string(format: .dayMonthHour) ?? "",
                                  descriptionTitle: LocalizationKeys.EventDetails.description.localize(),
                                  descriptionBody: event.details,
                                  locationTitle: LocalizationKeys.EventDetails.location.localize(),
                                  locationBody: event.location,
                                  primaryButton: EventDetails.Button(title: primaryButtonText, isLoading: false),
                                  secondaryButton: EventDetails.Button(title: LocalizationKeys.Buttons.navigate.localize(), isLoading: false))

    }
}
